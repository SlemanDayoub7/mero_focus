import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../domain/entities/overlay_timer_data.dart';
import '../../domain/repositories/background_services.dart';

/// Wraps `flutter_overlay_window` behind the app's own port.
///
/// `isActive()` can still report false for a moment right after
/// `showOverlay`. Trusting it made every following tick open another overlay
/// (duplicated windows), so this class remembers that it opened one and only
/// re-checks `isActive()` after a short grace period.
class FloatingOverlayServiceImpl implements FloatingOverlayService {
  FloatingOverlayServiceImpl();

  // Small pill: the overlay only shows the current time.
  static const int overlayHeight = 64;
  static const int overlayWidth = 150;
  static const Duration _grace = Duration(seconds: 4);

  bool _shown = false;
  DateTime? _shownAt;

  @override
  Future<bool> isPermissionGranted() => FlutterOverlayWindow.isPermissionGranted();

  @override
  Future<bool> requestPermission() async =>
      await FlutterOverlayWindow.requestPermission() ?? false;

  @override
  Future<bool> show({
    required String notificationTitle,
    required String notificationText,
    required OverlayTimerData data,
  }) async {
    if (!await isPermissionGranted()) return false;

    if (_shown || await isActive) {
      _shown = true;
      _shownAt ??= DateTime.now();
      await update(data);
      return true;
    }

    _shown = true;
    _shownAt = DateTime.now();
    await FlutterOverlayWindow.showOverlay(
      height: overlayHeight,
      width: overlayWidth,
      alignment: OverlayAlignment.topRight,
      enableDrag: true,
      positionGravity: PositionGravity.auto,
      overlayTitle: notificationTitle,
      overlayContent: notificationText,
    );
    // The overlay isolate may not be listening yet; the next tick resends.
    await update(data);
    return true;
  }

  @override
  Future<bool> update(OverlayTimerData data) async {
    if (!_shown) return false;

    final shownAt = _shownAt;
    final pastGrace =
        shownAt != null && DateTime.now().difference(shownAt) > _grace;
    if (pastGrace && !await isActive) {
      // The user dismissed it (or the system killed it).
      _shown = false;
      _shownAt = null;
      return false;
    }

    try {
      await FlutterOverlayWindow.shareData(data.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> close() async {
    _shown = false;
    _shownAt = null;
    if (await isActive) {
      await FlutterOverlayWindow.closeOverlay();
    }
    return true;
  }

  @override
  Future<bool> get isActive => FlutterOverlayWindow.isActive();
}
