import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/const/color_pallete.dart';

class CustomFluidBottomNavWidget extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomFluidBottomNavWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomFluidBottomNavWidget> createState() =>
      _CustomFluidBottomNavWidgetState();
}

class _CustomFluidBottomNavWidgetState extends State<CustomFluidBottomNavWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _curveAnimation;

  final List<Map<String, dynamic>> _navItems = [
    {'icon': 'assets/icons/Home.svg', 'label': 'home'},
    {'icon': 'assets/icons/star.svg', 'label': 'events'},
    {'icon': 'assets/icons/chat.svg', 'label': 'chat'},
    {'icon': 'assets/icons/heart.svg', 'label': 'community'},
    {'icon': 'assets/icons/navbarperson.svg', 'label': 'profile'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _curveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: ColorPalette.homeBottomNavBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Stack(
        children: [
          // Fluid curve effect
          _buildFluidCurve(),

          // Navigation items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                _navItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return _buildNavItem(index, item['icon']);
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFluidCurve() {
    return AnimatedBuilder(
      animation: _curveAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 80.h),
          painter: FluidCurvePainter(
            selectedIndex: widget.currentIndex,
            animationValue: _curveAnimation.value,
            itemCount: _navItems.length,
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, String iconPath) {
    final isSelected = widget.currentIndex == index;

    return GestureDetector(
      onTap: () {
        _animationController.reset();
        _animationController.forward();
        widget.onTap(index);
      },
      child: Container(
        width: 60.w,
        height: 80.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Blue dot above active icon
            if (isSelected)
              Container(
                width: 6.w,
                height: 6.h,
                margin: EdgeInsets.only(bottom: 4.h),
                decoration: BoxDecoration(
                  color: ColorPalette.homeTabActive,
                  shape: BoxShape.circle,
                ),
              ),

            // Icon
            SvgPicture.asset(
              iconPath,
              width: 24.w,
              height: 24.h,
              color:
                  isSelected
                      ? ColorPalette.homeTabActive
                      : const Color.fromARGB(177, 182, 186, 188),
            ),
          ],
        ),
      ),
    );
  }
}

class FluidCurvePainter extends CustomPainter {
  final int selectedIndex;
  final double animationValue;
  final int itemCount;

  FluidCurvePainter({
    required this.selectedIndex,
    required this.animationValue,
    required this.itemCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create the main navigation bar background
    final backgroundPaint =
        Paint()
          ..color = ColorPalette.homeBottomNavBg
          ..style = PaintingStyle.fill;

    final itemWidth = size.width / itemCount;
    final centerX = (selectedIndex * itemWidth) + (itemWidth / 2);
    final curveHeight = 18.0 * animationValue;
    final curveWidth = 25.0;

    // Create the fluid curve path (this will be subtracted)
    final curvePath = Path();

    // Start from top-left corner
    curvePath.moveTo(0, 0);

    // Line to start of curve
    curvePath.lineTo(centerX - curveWidth, 0);

    // Create more pronounced fluid curve
    curvePath.quadraticBezierTo(
      centerX - curveWidth + 8,
      curveHeight,
      centerX - curveWidth + 15,
      curveHeight * 0.6,
    );

    // Center dip
    curvePath.quadraticBezierTo(
      centerX,
      curveHeight * 1.2,
      centerX + curveWidth - 15,
      curveHeight * 0.6,
    );

    // Right side of curve
    curvePath.quadraticBezierTo(
      centerX + curveWidth - 8,
      curveHeight,
      centerX + curveWidth,
      0,
    );

    // Line to top-right corner
    curvePath.lineTo(size.width, 0);
    curvePath.lineTo(size.width, size.height);
    curvePath.lineTo(0, size.height);
    curvePath.close();

    // Create the full background path
    final backgroundPath =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Subtract the curve area to create transparency
    final finalPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      curvePath,
    );

    // Draw the navigation bar with the cutout
    canvas.drawPath(finalPath, backgroundPaint);

    // Draw the curve outline for the fluid effect
    final curvePaint =
        Paint()
          ..color = ColorPalette.homeBottomNavBg
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    // Create just the curve outline
    final outlinePath = Path();
    outlinePath.moveTo(centerX - curveWidth, 0);
    outlinePath.quadraticBezierTo(
      centerX - curveWidth + 8,
      curveHeight,
      centerX - curveWidth + 15,
      curveHeight * 0.6,
    );
    outlinePath.quadraticBezierTo(
      centerX,
      curveHeight * 1.2,
      centerX + curveWidth - 15,
      curveHeight * 0.6,
    );
    outlinePath.quadraticBezierTo(
      centerX + curveWidth - 8,
      curveHeight,
      centerX + curveWidth,
      0,
    );

    canvas.drawPath(outlinePath, curvePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is FluidCurvePainter &&
        (oldDelegate.selectedIndex != selectedIndex ||
            oldDelegate.animationValue != animationValue);
  }
}
