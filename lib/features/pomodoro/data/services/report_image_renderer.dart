import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle;

/// One small figure on the report (e.g. "Focus days" / "12").
class ReportPdfStat {
  const ReportPdfStat(this.label, this.value);

  final String label;
  final String value;
}

/// One horizontal bar (e.g. a subject): [fraction] is 0..1.
class ReportPdfRow {
  const ReportPdfRow({
    required this.label,
    required this.fraction,
    required this.value,
  });

  final String label;
  final double fraction;
  final String value;
}

/// Everything the report page needs, already localized and formatted, so the
/// renderer has no dependency on l10n or the database.
class ReportPdfData {
  const ReportPdfData({
    required this.isRtl,
    required this.title,
    required this.subtitle,
    required this.generated,
    required this.todayLabel,
    required this.todayValue,
    required this.goalText,
    required this.progress,
    required this.stats,
    required this.chartTitle,
    required this.peakLabel,
    required this.bars,
    required this.barLabels,
    required this.rowsTitle,
    required this.rows,
    required this.footer,
    this.background,
  });

  final bool isRtl;
  final String title;
  final String subtitle;
  final String generated;
  final String todayLabel;
  final String todayValue;
  final String goalText;
  final double progress;
  final List<ReportPdfStat> stats;
  final String chartTitle;
  final String peakLabel;
  final List<double> bars;
  final List<String> barLabels;
  final String rowsTitle;
  final List<ReportPdfRow> rows;
  final String footer;

  /// Optional picture drawn behind the whole page (cover-fit, with a light
  /// veil so the cards stay readable). The caller owns and disposes it.
  final ui.Image? background;
}

/// Draws a one-page A4 report with the Flutter text engine (so Arabic is
/// shaped and laid out correctly) and returns it as PNG bytes. The PDF just
/// wraps this image.
abstract final class ReportImageRenderer {
  static const double pageWidth = 595;
  static const double pageHeight = 842;
  static const double _scale = 3;

  static Future<Uint8List> renderPng(ReportPdfData data) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(
      recorder,
      const ui.Rect.fromLTWH(0, 0, pageWidth * _scale, pageHeight * _scale),
    );
    canvas.scale(_scale, _scale);
    _ReportPainter(canvas, data.isRtl, data.background != null).paint(data);

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (pageWidth * _scale).round(),
      (pageHeight * _scale).round(),
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) throw StateError('Could not encode the report image');
    return bytes.buffer.asUint8List();
  }
}

class _ReportPainter {
  _ReportPainter(this.canvas, this.rtl, this.hasBackground);

  final ui.Canvas canvas;
  final bool rtl;
  final bool hasBackground;

  static const double _w = ReportImageRenderer.pageWidth;
  static const double _margin = 32;
  static const double _contentWidth = _w - 2 * _margin;

  static const ui.Color _primary = ui.Color(0xFF2E6FD8);
  static const ui.Color _primaryLight = ui.Color(0xFF5B8DEF);
  static const ui.Color _ink = ui.Color(0xFF1B2333);
  static const ui.Color _muted = ui.Color(0xFF6B7487);
  static const ui.Color _track = ui.Color(0xFFE6EAF5);
  static const ui.Color _cardBorder = ui.Color(0xFFE3E7F1);

  /// Rect given in left-to-right coordinates, mirrored when the page is RTL.
  ui.Rect _rect(double x, double y, double w, double h) {
    return ui.Rect.fromLTWH(rtl ? _w - x - w : x, y, w, h);
  }

  void _card(double x, double y, double w, double h) {
    final rrect = ui.RRect.fromRectAndRadius(
      _rect(x, y, w, h),
      const ui.Radius.circular(20),
    );
    canvas.drawRRect(
      rrect,
      ui.Paint()
        ..color = hasBackground
            ? const ui.Color(0xEBFFFFFF)
            : const ui.Color(0xFFFFFFFF),
    );
    canvas.drawRRect(
      rrect,
      ui.Paint()
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = _cardBorder,
    );
  }

  void _text(
    String text, {
    required double x,
    required double y,
    required double width,
    required double size,
    ui.Color color = _ink,
    bool bold = false,
    ui.TextAlign align = ui.TextAlign.start,
    int maxLines = 1,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: bold ? ui.FontWeight.w700 : ui.FontWeight.w400,
        ),
      ),
      textDirection: rtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      textAlign: align,
      maxLines: maxLines,
      ellipsis: '…',
    )..layout(minWidth: width, maxWidth: width);
    final target = _rect(x, y, width, painter.height);
    painter.paint(canvas, ui.Offset(target.left, target.top));
  }

  void _bar(double x, double y, double w, double h, ui.Color color, double r) {
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(_rect(x, y, w, h), ui.Radius.circular(r)),
      ui.Paint()..color = color,
    );
  }

  void paint(ReportPdfData d) {
    const page = ui.Rect.fromLTWH(0, 0, _w, ReportImageRenderer.pageHeight);
    canvas.drawRect(page, ui.Paint()..color = const ui.Color(0xFFF5F7FC));
    final background = d.background;
    if (background != null) {
      _drawCover(background, page);
      canvas.drawRect(page, ui.Paint()..color = const ui.Color(0x8CF5F7FC));
    }

    _header(d);
    _todayCard(d);
    _statsGrid(d);
    _chartCard(d);
    _rowsCard(d);

    _text(
      d.footer,
      x: _margin,
      y: 820,
      width: _contentWidth,
      size: 10,
      color: _muted,
      align: ui.TextAlign.center,
    );
  }

  /// Draws [image] scaled to fill [target], cropping the overflow (cover).
  void _drawCover(ui.Image image, ui.Rect target) {
    final iw = image.width.toDouble();
    final ih = image.height.toDouble();
    final scale = math.max(target.width / iw, target.height / ih);
    final srcW = target.width / scale;
    final srcH = target.height / scale;
    final src = ui.Rect.fromLTWH((iw - srcW) / 2, (ih - srcH) / 2, srcW, srcH);
    canvas.drawImageRect(
      image,
      src,
      target,
      ui.Paint()..filterQuality = ui.FilterQuality.medium,
    );
  }

  void _header(ReportPdfData d) {
    const rect = ui.Rect.fromLTWH(0, 0, _w, 130);
    canvas.drawRRect(
      ui.RRect.fromRectAndCorners(
        rect,
        bottomLeft: const ui.Radius.circular(28),
        bottomRight: const ui.Radius.circular(28),
      ),
      ui.Paint()
        ..shader = ui.Gradient.linear(
          const ui.Offset(0, 0),
          const ui.Offset(_w, 130),
          const <ui.Color>[_primary, _primaryLight],
        ),
    );
    const white = ui.Color(0xFFFFFFFF);
    _text(
      d.title,
      x: _margin,
      y: 32,
      width: _contentWidth,
      size: 26,
      color: white,
      bold: true,
    );
    _text(
      d.subtitle,
      x: _margin,
      y: 70,
      width: _contentWidth,
      size: 13,
      color: const ui.Color(0xE6FFFFFF),
    );
    _text(
      d.generated,
      x: _margin,
      y: 92,
      width: _contentWidth,
      size: 11,
      color: const ui.Color(0xB3FFFFFF),
    );
  }

  void _todayCard(ReportPdfData d) {
    const y = 146.0;
    const h = 116.0;
    _card(_margin, y, _contentWidth, h);

    const radius = 38.0;
    const ringX = _margin + 16 + radius + 4;
    const ringY = y + h / 2;
    final center = ui.Offset(rtl ? _w - ringX : ringX, ringY);
    final ringRect = ui.Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      ui.Paint()
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 11
        ..color = _track,
    );
    final progress = d.progress.clamp(0.0, 1.0).toDouble();
    if (progress > 0) {
      canvas.drawArc(
        ringRect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        ui.Paint()
          ..style = ui.PaintingStyle.stroke
          ..strokeWidth = 11
          ..strokeCap = ui.StrokeCap.round
          ..color = _primary,
      );
    }
    _text(
      '${(progress * 100).round()}%',
      x: ringX - radius,
      y: ringY - 12,
      width: radius * 2,
      size: 20,
      bold: true,
      align: ui.TextAlign.center,
    );

    const textX = _margin + 16 + radius * 2 + 28;
    const textW = _contentWidth - (textX - _margin) - 16;
    _text(
      d.todayLabel,
      x: textX,
      y: y + 18,
      width: textW,
      size: 12,
      color: _muted,
    );
    _text(
      d.todayValue,
      x: textX,
      y: y + 36,
      width: textW,
      size: 28,
      bold: true,
    );
    _text(
      d.goalText,
      x: textX,
      y: y + 76,
      width: textW,
      size: 12,
      color: _muted,
      maxLines: 2,
    );
  }

  void _statsGrid(ReportPdfData d) {
    const top = 276.0;
    const gap = 10.0;
    const cardH = 62.0;
    const cardW = (_contentWidth - 12) / 2;
    final count = math.min(d.stats.length, 4);
    for (var i = 0; i < count; i++) {
      final col = i % 2;
      final row = i ~/ 2;
      final x = _margin + col * (cardW + 12);
      final y = top + row * (cardH + gap);
      _card(x, y, cardW, cardH);
      _text(
        d.stats[i].value,
        x: x + 16,
        y: y + 10,
        width: cardW - 32,
        size: 20,
        bold: true,
        color: _primary,
      );
      _text(
        d.stats[i].label,
        x: x + 16,
        y: y + 38,
        width: cardW - 32,
        size: 11,
        color: _muted,
      );
    }
  }

  void _chartCard(ReportPdfData d) {
    const y = 424.0;
    const h = 170.0;
    _card(_margin, y, _contentWidth, h);

    const inner = _contentWidth - 32;
    _text(
      d.chartTitle,
      x: _margin + 16,
      y: y + 12,
      width: inner,
      size: 14,
      bold: true,
    );
    _text(
      d.peakLabel,
      x: _margin + 16,
      y: y + 14,
      width: inner,
      size: 11,
      color: _muted,
      align: ui.TextAlign.end,
    );

    final bars = d.bars;
    if (bars.isEmpty) return;
    const top = y + 40;
    const baseline = y + 138;
    const area = baseline - top;
    var peak = 0.0;
    var peakIndex = -1;
    for (var i = 0; i < bars.length; i++) {
      if (bars[i] > peak) {
        peak = bars[i];
        peakIndex = i;
      }
    }
    final slot = inner / bars.length;
    final barWidth = math.max(3.0, slot * 0.62);
    for (var i = 0; i < bars.length; i++) {
      final v = bars[i];
      final height = v <= 0 ? 3.0 : 6 + (v / peak) * (area - 6);
      final color = v <= 0
          ? _track
          : (i == peakIndex ? _primary : const ui.Color(0x8C2E6FD8));
      _bar(
        _margin + 16 + i * slot + (slot - barWidth) / 2,
        baseline - height,
        barWidth,
        height,
        color,
        3,
      );
      if (i < d.barLabels.length && d.barLabels[i].isNotEmpty) {
        _text(
          d.barLabels[i],
          x: _margin + 16 + i * slot - 4,
          y: baseline + 4,
          width: slot + 8,
          size: 9,
          color: _muted,
          align: ui.TextAlign.center,
        );
      }
    }
  }

  void _rowsCard(ReportPdfData d) {
    const y = 608.0;
    const h = 200.0;
    _card(_margin, y, _contentWidth, h);
    const inner = _contentWidth - 32;
    _text(
      d.rowsTitle,
      x: _margin + 16,
      y: y + 14,
      width: inner,
      size: 14,
      bold: true,
    );

    final rows = d.rows.take(5).toList();
    for (var i = 0; i < rows.length; i++) {
      final rowY = y + 44 + i * 30.0;
      final row = rows[i];
      _text(
        row.label,
        x: _margin + 16,
        y: rowY,
        width: inner - 110,
        size: 12,
      );
      _text(
        row.value,
        x: _margin + 16 + inner - 106,
        y: rowY,
        width: 106,
        size: 12,
        color: _muted,
        align: ui.TextAlign.end,
      );
      _bar(_margin + 16, rowY + 18, inner, 6, _track, 3);
      final fraction = row.fraction.clamp(0.0, 1.0).toDouble();
      if (fraction > 0) {
        _bar(_margin + 16, rowY + 18, math.max(6.0, inner * fraction), 6, _primary, 3);
      }
    }
  }
}
