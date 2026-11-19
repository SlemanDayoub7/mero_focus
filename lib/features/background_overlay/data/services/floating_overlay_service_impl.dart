import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../domain/entities/overlay_timer_data.dart';
import '../../domain/repositories/background_services.dart';

/// Wraps `flutter_overlay_window` behind the app's own port.
class FloatingOverlayServiceImpl implements FloatingOverlayService {
  const FloatingOverlayServiceImpl();

  static const int overlayHeight = 96;
  static const int overlayWidth = 240;

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
    if (!await isActive) {
      await FlutterOverlayWindow.showOverlay(
        height: overlayHeight,
        width: overlayWidth,
        alignment: OverlayAlignment.topRight,
        enableDrag: true,
        positionGravity: PositionGravity.auto,
        overlayTitle: notificationTitle,
        overlayContent: notificationText,
      );
    }
    await update(data);
    return isActive;
  }

  @override
  Future<bool> update(OverlayTimerData data) async {
    if (!await isActive) return false;
    await FlutterOverlayWindow.shareData(data.toJson());
    return true;
  }

  @override
  Future<bool> close() async {
    if (!await isActive) return true;
    await FlutterOverlayWindow.closeOverlay();
    return true;
  }

  @override
  Future<bool> get isActive => FlutterOverlayWindow.isActive();
}
