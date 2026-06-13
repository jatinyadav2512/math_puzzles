import 'package:flutter/material.dart';
import 'package:math_riddles/core/theme/app_colors.dart';
import 'package:math_riddles/core/theme/app_spacing.dart';
import 'package:math_riddles/core/theme/app_text_styles.dart';
import 'dart:math' as math;

class GridGivensBlock extends StatelessWidget {
  const GridGivensBlock({super.key, required this.cells, required this.colors});

  final List<List<int?>> cells;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.brandPrimary.withOpacity(0.5), width: 2),
            borderRadius: BorderRadius.circular(8),
            color: colors.surface,
          ),
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            border: TableBorder.all(
              color: AppColors.brandPrimary.withOpacity(0.2),
              width: 1.5,
              borderRadius: BorderRadius.circular(8),
            ),
            children: cells.map((row) {
              return TableRow(
                children: row.map((cell) {
                  final isMissing = cell == null;
                  return Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    child: Text(
                      isMissing ? '?' : cell.toString(),
                      style: AppTextStyles.riddleEquation.copyWith(
                        color: isMissing ? AppColors.brandPrimary : colors.onSurface,
                        fontSize: 24,
                        fontWeight: isMissing ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class SudokuGivensBlock extends StatelessWidget {
  const SudokuGivensBlock({super.key, required this.cells, required this.colors});

  final List<List<int?>> cells;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: colors.onSurfaceMuted, width: 3),
            borderRadius: BorderRadius.circular(8),
            color: colors.surface,
          ),
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            border: TableBorder.symmetric(
              inside: BorderSide(color: colors.divider, width: 1),
            ),
            children: List.generate(4, (r) {
              return TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: r == 1 ? colors.onSurfaceMuted : Colors.transparent,
                      width: r == 1 ? 3 : 0,
                    ),
                  ),
                ),
                children: List.generate(4, (c) {
                  final cell = cells[r][c];
                  final isMissing = cell == null;
                  return Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: c == 1 ? colors.onSurfaceMuted : Colors.transparent,
                          width: c == 1 ? 3 : 0,
                        ),
                      ),
                    ),
                    child: Text(
                      isMissing ? '?' : cell.toString(),
                      style: AppTextStyles.riddleEquation.copyWith(
                        color: isMissing ? AppColors.brandPrimary : colors.onSurface,
                        fontSize: 22,
                        fontWeight: isMissing ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class CircleGivensBlock extends StatelessWidget {
  const CircleGivensBlock({super.key, required this.cells, required this.colors});

  final List<List<int?>> cells;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    int maxSlices = 0;
    for (final ring in cells) {
      if (ring.length > maxSlices) maxSlices = ring.length;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: SizedBox(
          width: 240,
          height: 240,
          child: CustomPaint(
            painter: _CirclePainter(colors: colors, ringCount: cells.length, maxSlices: maxSlices),
            child: Stack(
              children: [
                for (var r = 0; r < cells.length; r++)
                  for (var i = 0; i < cells[r].length; i++)
                    _buildText(
                      cells[r][i],
                      ringIndex: r,
                      totalRings: cells.length,
                      sliceIndex: i,
                      totalSlices: cells[r].length,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText(int? val, {
    required int ringIndex, required int totalRings,
    required int sliceIndex, required int totalSlices
  }) {
    final isMissing = val == null;
    final text = isMissing ? '?' : val.toString();
    
    const double width = 240.0;
    const double height = 240.0;
    
    const center = Offset(width / 2, height / 2);
    const maxRadius = width / 2;
    
    final ringWidth = maxRadius / totalRings;
    final radius = (ringIndex + 0.5) * ringWidth;
    
    final sweepAngle = 2 * math.pi / totalSlices;
    const startAngle = -math.pi / 2;
    final angle = startAngle + (sliceIndex + 0.5) * sweepAngle;

    final x = center.dx + radius * math.cos(angle);
    final y = center.dy + radius * math.sin(angle);

    return Positioned(
      left: x - 24,
      top: y - 24,
      width: 48,
      height: 48,
      child: Center(
        child: Text(
          text,
          style: AppTextStyles.riddleEquation.copyWith(
            color: isMissing ? AppColors.brandPrimary : colors.onSurface,
            fontSize: 22,
            fontWeight: isMissing ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({required this.colors, required this.ringCount, required this.maxSlices});
  final AppColors colors;
  final int ringCount;
  final int maxSlices;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    
    final paint = Paint()
      ..color = AppColors.brandPrimary.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var i = 1; i <= ringCount; i++) {
      canvas.drawCircle(center, maxRadius * (i / ringCount), paint);
    }
    
    for (var i = 0; i < maxSlices; i++) {
      final angle = -math.pi / 2 + (i * 2 * math.pi / maxSlices);
      final x = center.dx + maxRadius * math.cos(angle);
      final y = center.dy + maxRadius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) => true;
}

class BoxGivensBlock extends StatelessWidget {
  const BoxGivensBlock({super.key, required this.cells, required this.colors});

  final List<List<int?>> cells;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: cells.map((boxData) => _buildBox(boxData)).toList(),
        ),
      ),
    );
  }

  Widget _buildBox(List<int?> data) {
    final tl = data.isNotEmpty ? data[0] : null;
    final tr = data.length > 1 ? data[1] : null;
    final bl = data.length > 2 ? data[2] : null;
    final br = data.length > 3 ? data[3] : null;
    final center = data.length > 4 ? data[4] : null;

    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.brandPrimary.withOpacity(0.5), width: 2),
                borderRadius: BorderRadius.circular(8),
                color: colors.surface,
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _CrossPainter(color: AppColors.brandPrimary.withOpacity(0.2)),
            ),
          ),
          Align(alignment: Alignment.topLeft, child: _padText(tl)),
          Align(alignment: Alignment.topRight, child: _padText(tr)),
          Align(alignment: Alignment.bottomLeft, child: _padText(bl)),
          Align(alignment: Alignment.bottomRight, child: _padText(br)),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colors.surfaceMuted,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.brandPrimary, width: 2),
              ),
              alignment: Alignment.center,
              child: _text(center),
            ),
          ),
        ],
      ),
    );
  }

  Widget _padText(int? val) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: _text(val),
  );

  Widget _text(int? val) {
    final isMissing = val == null;
    return Text(
      isMissing ? '?' : val.toString(),
      style: AppTextStyles.riddleEquation.copyWith(
        color: isMissing ? AppColors.brandPrimary : colors.onSurface,
        fontSize: 18,
        fontWeight: isMissing ? FontWeight.bold : FontWeight.w600,
      ),
    );
  }
}

class _CrossPainter extends CustomPainter {
  _CrossPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }
  @override
  bool shouldRepaint(covariant _CrossPainter oldDelegate) => false;
}

class MagicTriangleGivensBlock extends StatelessWidget {
  const MagicTriangleGivensBlock({super.key, required this.cells, required this.colors});

  final List<List<int?>> cells;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(200, 160),
            painter: _TriangleLinesPainter(color: AppColors.brandPrimary.withOpacity(0.3)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var row in cells)
                Padding(
                  padding: EdgeInsets.only(bottom: row == cells.last ? 0 : 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var cell in row)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: colors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.brandPrimary, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: _text(cell),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _text(int? val) {
    final isMissing = val == null;
    return Text(
      isMissing ? '?' : val.toString(),
      style: AppTextStyles.riddleEquation.copyWith(
        color: isMissing ? AppColors.brandPrimary : colors.onSurface,
        fontSize: 20,
        fontWeight: isMissing ? FontWeight.bold : FontWeight.w600,
      ),
    );
  }
}

class _TriangleLinesPainter extends CustomPainter {
  _TriangleLinesPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant _TriangleLinesPainter oldDelegate) => false;
}
