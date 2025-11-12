import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/const/color_pallete.dart';
import '../../controllers/home_cubit.dart';
import '../../controllers/home_state.dart';

class HomeActivityGridWidget extends StatefulWidget {
  const HomeActivityGridWidget({super.key});

  @override
  State<HomeActivityGridWidget> createState() => _HomeActivityGridWidgetState();
}

class _HomeActivityGridWidgetState extends State<HomeActivityGridWidget>
    with TickerProviderStateMixin {
  List<Map<String, double>> _currentPositions = [];
  List<AnimationController> _repulsionControllers = [];
  List<Animation<Offset>> _repulsionAnimations = [];
  AnimationController? _scaleController;
  Animation<double>? _scaleAnimation;
  bool _isDragging = false;
  int? _draggedIndex;

  @override
  void initState() {
    super.initState();
    // Initialize scale animation for selected circle
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _scaleController!, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    for (var controller in _repulsionControllers) {
      controller.dispose();
    }
    _scaleController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
          height: 600.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorPalette.homeTabInactiveBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRect(
            child: InteractiveViewer(
              panEnabled: !_isDragging, // Disable panning when dragging
              scaleEnabled: false,
              minScale: 1.0,
              maxScale: 1.0,
              constrained: false,
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // Full screen width
                height: 700.h, // Match container height for better positioning
                child: Stack(
                  children: [
                    // Figma background vectors
                    _buildBackgroundVectors(context),
                    // Content on top
                    _buildContent(context, state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, HomeState state) {
    if (state.isLoading && state.users.isEmpty) {
      return _buildShimmerActivityGrid();
    }

    if (state.isError && state.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Failed to load users',
              style: TextStyle(fontSize: 16.sp, color: Colors.red),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.read<HomeCubit>().refreshUsers(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Use real user data or fallback to static positions
    final users = state.users;
    if (users.isEmpty) {
      return _buildEmptyState();
    }

    return _buildDynamicActivityGrid(users);
  }

  Widget _buildShimmerActivityGrid() {
    // Generate positions for shimmer circles (similar to real data)
    final shimmerPositions = _generateDynamicPositions(
      8,
    ); // Show 8 shimmer circles

    return Builder(
      builder:
          (context) => Stack(
            children: [
              // Background vectors
              _buildBackgroundVectors(context),
              // Shimmer circles
              ...shimmerPositions.asMap().entries.map((entry) {
                final index = entry.key;
                final position = entry.value;

                return _buildShimmerActivityCircle(
                  position['x']!,
                  position['y']!,
                  index,
                );
              }).toList(),
            ],
          ),
    );
  }

  Widget _buildShimmerActivityCircle(double left, double top, int index) {
    return Positioned(
      left: left,
      top: top,
      child: Shimmer.fromColors(
        baseColor: const Color(0xFF2A3A4A).withOpacity(0.3),
        highlightColor: const Color(0xFFFFFFFF).withOpacity(0.8),
        period: Duration(milliseconds: 1200 + (index * 200)),
        child: Stack(
          children: [
            // Main circle shimmer with gradient effect
            Container(
              width: 63.w,
              height: 63.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF3A4A5A).withOpacity(0.4),
                    const Color(0xFF2A3A4A).withOpacity(0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            // Activity icon shimmer with enhanced visibility
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 22.5.w,
                height: 22.5.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF4A5A6A).withOpacity(0.5),
                      const Color(0xFF3A4A5A).withOpacity(0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64.w,
            color: Colors.grey.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'No users available',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Pull to refresh or check your connection',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicActivityGrid(List<dynamic> users) {
    // Initialize positions if empty
    if (_currentPositions.isEmpty) {
      _currentPositions = _generateDynamicPositions(users.length);
      _initializeRepulsionControllers(users.length);
    }

    // Border colors for variety
    final borderColors = [
      ColorPalette.homeActivityBorder,
      ColorPalette.homeActivityBorderBlue,
      ColorPalette.homeActivityBorderGreen,
      ColorPalette.homeActivityBorderYellow,
      ColorPalette.homeActivityBorderDark,
    ];

    return Stack(
      children: [
        // Scrollable user activity circles with animations and dragging
        ...users.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;

          if (index >= _currentPositions.length) return const SizedBox.shrink();

          final position = _currentPositions[index];
          final borderColor = borderColors[index % borderColors.length];

          // Determine activity type based on user interests
          final activityType = _getActivityTypeFromInterests(user.interests);

          return _buildDraggableAnimatedUserActivityCircle(
            position['x']!,
            position['y']!,
            user,
            borderColor,
            activityType,
            index,
          );
        }).toList(),
      ],
    );
  }

  List<Map<String, double>> _generateDynamicPositions(int userCount) {
    // Use current time as seed to ensure different positions each time
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    final positions = <Map<String, double>>[];
    final usedPositions = <Map<String, double>>[];

    // Define grid boundaries - use actual screen width for better responsiveness
    final screenWidth = 400.w; // Standard mobile width
    final screenHeight = 550.h; // Container height
    final circleSize = 63.w; // User circle size
    final minSpacing = 90.w; // Increased minimum distance for better spacing

    // Define safe zones (avoid edges)
    final marginX = 30.w; // Increased margin for better edge spacing
    final marginY = 30.h;
    final maxX = screenWidth - circleSize - marginX;
    final maxY = screenHeight - circleSize - marginY;

    // Generate positions with collision detection
    for (int i = 0; i < userCount; i++) {
      int attempts = 0;
      Map<String, double>? validPosition;

      while (attempts < 50 && validPosition == null) {
        final x = marginX + random.nextDouble() * (maxX - marginX);
        final y = marginY + random.nextDouble() * (maxY - marginY);

        final newPosition = {'x': x, 'y': y};

        // Check collision with existing positions
        bool hasCollision = false;
        for (final existingPos in usedPositions) {
          final distance = _calculateDistance(
            x,
            y,
            existingPos['x']!,
            existingPos['y']!,
          );

          if (distance < minSpacing) {
            hasCollision = true;
            break;
          }
        }

        if (!hasCollision) {
          validPosition = newPosition;
          usedPositions.add(newPosition);
        }

        attempts++;
      }

      // If no valid position found after 50 attempts, use a fallback
      if (validPosition == null) {
        validPosition = _generateFallbackPosition(
          i,
          usedPositions,
          maxX,
          maxY,
          marginX,
          marginY,
        );
        usedPositions.add(validPosition);
      }

      positions.add(validPosition);
    }

    return positions;
  }

  double _calculateDistance(double x1, double y1, double x2, double y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  Map<String, double> _generateFallbackPosition(
    int index,
    List<Map<String, double>> usedPositions,
    double maxX,
    double maxY,
    double marginX,
    double marginY,
  ) {
    // Create a more organized grid-based fallback system
    final gridCols = 5; // Increased columns for better distribution
    final gridRows = 6; // Adjusted rows for better fit
    final cellWidth = (maxX - marginX) / gridCols;
    final cellHeight = (maxY - marginY) / gridRows;

    final col = index % gridCols;
    final row = (index / gridCols).floor();

    // Add controlled randomness within the cell for natural look
    final random = Random();
    final cellMarginX = cellWidth * 0.1; // 10% margin within cell
    final cellMarginY = cellHeight * 0.1;

    final x =
        marginX +
        (col * cellWidth) +
        cellMarginX +
        (random.nextDouble() * (cellWidth - 2 * cellMarginX));
    final y =
        marginY +
        (row * cellHeight) +
        cellMarginY +
        (random.nextDouble() * (cellHeight - 2 * cellMarginY));

    return {'x': x, 'y': y};
  }

  String _getActivityTypeFromInterests(List<String> interests) {
    // Map interests to activity types
    for (final interest in interests) {
      switch (interest.toLowerCase()) {
        case 'running':
        case 'jogging':
          return 'running';
        case 'biking':
        case 'cycling':
          return 'biking';
        case 'weightlift':
        case 'weightlifting':
          return 'weightlifting';
        case 'hiking':
          return 'hiking';
        default:
          return 'running'; // Default activity
      }
    }
    return 'running'; // Default if no interests
  }

  void _initializeRepulsionControllers(int count) {
    // Dispose existing controllers
    for (var controller in _repulsionControllers) {
      controller.dispose();
    }

    _repulsionControllers.clear();
    _repulsionAnimations.clear();

    for (int i = 0; i < count; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );
      _repulsionControllers.add(controller);
      _repulsionAnimations.add(
        Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut)),
      );
    }
  }

  Widget _buildDraggableAnimatedUserActivityCircle(
    double left,
    double top,
    dynamic user,
    Color borderColor,
    String activityType,
    int index,
  ) {
    return TweenAnimationBuilder<Offset>(
      duration: Duration(milliseconds: 800 + (index * 150)),
      tween: Tween<Offset>(
        begin: Offset(left + 100, top + 100), // Start from center-ish position
        end: Offset(left, top),
      ),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Positioned(
          left: value.dx,
          top: value.dy,
          child: TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 600 + (index * 100)),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: _buildDraggableUserActivityCircle(
                  left,
                  top,
                  user,
                  borderColor,
                  activityType,
                  index,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDraggableUserActivityCircle(
    double left,
    double top,
    dynamic user,
    Color borderColor,
    String activityType,
    int index,
  ) {
    final isSelected = _isDragging && _draggedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Enable immediate response
      onPanStart: (details) {
        // Immediate feedback when starting to drag
        setState(() {
          _isDragging = true;
          _draggedIndex = index;
        });
        _scaleController?.forward();
      },
      onPanUpdate: (details) {
        if (_isDragging && _draggedIndex == index) {
          setState(() {
            _currentPositions[index] = {
              'x': _currentPositions[index]['x']! + details.delta.dx,
              'y': _currentPositions[index]['y']! + details.delta.dy,
            };
          });
          _checkCollisions(index);
        }
      },
      onPanEnd: (details) {
        setState(() {
          _isDragging = false;
          _draggedIndex = null;
        });
        _scaleController?.reverse();
      },
      onPanCancel: () {
        setState(() {
          _isDragging = false;
          _draggedIndex = null;
        });
        _scaleController?.reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _repulsionAnimations[index],
          _scaleAnimation ??
              _scaleController ??
              const AlwaysStoppedAnimation(1.0),
        ]),
        builder: (context, child) {
          final scale = isSelected ? (_scaleAnimation?.value ?? 1.0) : 1.0;
          return Transform.translate(
            offset: _repulsionAnimations[index].value,
            child: Transform.scale(
              scale: scale,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: borderColor.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                          : null,
                ),
                child: _buildUserActivityCircle(
                  left,
                  top,
                  user,
                  borderColor,
                  activityType,
                  index,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _checkCollisions(int draggedIndex) {
    if (draggedIndex >= _currentPositions.length) return;

    final draggedPos = _currentPositions[draggedIndex];
    final minDistance = 90.w; // Minimum distance between circles

    for (int i = 0; i < _currentPositions.length; i++) {
      if (i == draggedIndex) continue;

      final otherPos = _currentPositions[i];
      final distance = _calculateDistance(
        draggedPos['x']!,
        draggedPos['y']!,
        otherPos['x']!,
        otherPos['y']!,
      );

      if (distance < minDistance) {
        _repelCircle(i, draggedIndex, minDistance - distance);
      }
    }
  }

  void _repelCircle(int repelledIndex, int draggedIndex, double overlap) {
    if (repelledIndex >= _currentPositions.length) return;

    final draggedPos = _currentPositions[draggedIndex];
    final repelledPos = _currentPositions[repelledIndex];

    // Calculate repulsion direction
    final dx = repelledPos['x']! - draggedPos['x']!;
    final dy = repelledPos['y']! - draggedPos['y']!;
    final distance = sqrt(dx * dx + dy * dy);

    if (distance == 0) return;

    // Water-like repulsion with smooth curves
    final repulsionStrength = (overlap * 0.8).clamp(10.0, 50.0);
    final repulsionX = (dx / distance) * repulsionStrength;
    final repulsionY = (dy / distance) * repulsionStrength;

    // Update position smoothly
    setState(() {
      _currentPositions[repelledIndex] = {
        'x': repelledPos['x']! + repulsionX,
        'y': repelledPos['y']! + repulsionY,
      };
    });

    // Create water-like wave animation
    _createWaterRepulsionAnimation(repelledIndex, repulsionX, repulsionY);
  }

  void _createWaterRepulsionAnimation(
    int index,
    double repulsionX,
    double repulsionY,
  ) {
    if (index >= _repulsionControllers.length) return;

    // Create a wave-like animation that oscillates back and forth
    final controller = _repulsionControllers[index];

    // Set up the animation to create a water ripple effect
    _repulsionAnimations[index] = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset.zero,
          end: Offset(repulsionX * 0.3, repulsionY * 0.3),
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(repulsionX * 0.3, repulsionY * 0.3),
          end: Offset(-repulsionX * 0.1, -repulsionY * 0.1),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(-repulsionX * 0.1, -repulsionY * 0.1),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(controller);

    // Start the water wave animation
    controller.forward().then((_) {
      controller.reset();
    });
  }

  Widget _buildUserActivityCircle(
    double left,
    double top,
    dynamic user,
    Color borderColor,
    String activityType, [
    int? index,
  ]) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to user profile or start activity
        // User tapped: ${user.fullName}
      },
      child: Stack(
        children: [
          // Main circle with user profile picture
          Container(
            width: 63.w,
            height: 63.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Container(
              margin: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image:
                    user.profilePic != null
                        ? DecorationImage(
                          image: NetworkImage(user.profilePic),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {
                            // Handle network image error
                          },
                        )
                        : DecorationImage(
                          image: AssetImage(
                            user.gender == 'male'
                                ? 'assets/images/fitness_partner.png'
                                : 'assets/images/friends_step.png',
                          ),
                          fit: BoxFit.cover,
                        ),
              ),
            ),
          ),

          // Activity icon overlay with animation
          Positioned(
            bottom: 0,
            left: 0,
            child:
                index != null
                    ? TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 400 + (index * 50)),
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      curve: Curves.bounceOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 22.5.w,
                            height: 22.5.h,
                            decoration: const BoxDecoration(
                              color: ColorPalette.textWhite,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getActivityIcon(activityType),
                              size: 12.w,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    )
                    : Container(
                      width: 22.5.w,
                      height: 22.5.h,
                      decoration: const BoxDecoration(
                        color: ColorPalette.textWhite,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getActivityIcon(activityType),
                        size: 12.w,
                        color: Colors.black,
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'running':
      case 'jogging':
        return Icons.directions_run;
      case 'biking':
      case 'cycling':
        return Icons.directions_bike;
      case 'weightlift':
      case 'weightlifting':
        return Icons.fitness_center;
      case 'hiking':
        return Icons.hiking;
      default:
        return Icons.directions_run;
    }
  }

  Widget _buildBackgroundVectors(BuildContext context) {
    return Stack(
      children: [
        // Top background vector - full width
        Positioned(
          top: -300.h,
          right: 0.w,
          child: SvgPicture.asset(
            'assets/icons/Solid health plus alt.svg',
            width: MediaQuery.of(context).size.width,
            height: 830.h,
          ),
        ),
        // Bottom background vector - full width
        Positioned(
          bottom: -50.h,
          left: 0.w,
          child: SvgPicture.asset(
            'assets/icons/Solid health plus alt bottom.svg',
            width: MediaQuery.of(context).size.width,
            height: 664.h,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
