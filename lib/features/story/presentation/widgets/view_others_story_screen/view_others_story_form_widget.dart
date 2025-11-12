import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/animation_helper.dart';
import '../../controllers/story_cubit.dart';
import '../../controllers/story_state.dart';

// Custom painter for the triangular pointer
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw shadow first
    final shadowPaint =
        Paint()
          ..color = const Color.fromARGB(255, 255, 255, 255).withOpacity(0.15)
          ..style = PaintingStyle.fill;

    final shadowPath = Path();
    shadowPath.moveTo(size.width - 2, size.height / 2); // Right point
    shadowPath.lineTo(2, 2); // Top left
    shadowPath.lineTo(2, size.height - 2); // Bottom left
    shadowPath.close();

    canvas.drawPath(shadowPath, shadowPaint);

    // Draw main triangle pointing to the right
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, size.height / 2); // Right point (tip)
    path.lineTo(0, 0); // Top left
    path.lineTo(0, size.height); // Bottom left
    path.close();

    canvas.drawPath(path, paint);

    // Draw border for better visibility
    final borderPaint =
        Paint()
          ..color = const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ViewOthersStoryFormWidget extends StatefulWidget {
  final String userId;
  final String userName;
  final String? userProfilePic;

  const ViewOthersStoryFormWidget({
    super.key,
    required this.userId,
    required this.userName,
    this.userProfilePic,
  });

  @override
  State<ViewOthersStoryFormWidget> createState() =>
      _ViewOthersStoryFormWidgetState();
}

class _ViewOthersStoryFormWidgetState extends State<ViewOthersStoryFormWidget> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        return Stack(
          children: [
            // Story Content
            if (state.isLoadingUserStories)
              _buildLoadingView()
            else if (state.userStories.isEmpty)
              _buildEmptyView()
            else
              _buildStoryView(state),

            // Top Header
            _buildTopHeader(state),

            // Bottom Actions
            if (!state.isLoadingUserStories) _buildBottomActions(),
          ],
        );
      },
    );
  }

  Widget _buildLoadingView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64.w,
              color: Colors.white.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No stories available',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryView(StoryState state) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemCount: state.userStories.length,
      itemBuilder: (context, index) {
        final story = state.userStories[index];
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Stack(
            children: [
              // Story Image with animation
              Positioned.fill(
                child: AnimationHelper.fadeIn(
                  duration: const Duration(milliseconds: 600),
                  child: Image.network(
                    story.url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.withOpacity(0.3),
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopHeader(StoryState state) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 138.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0x73222B2B), // #322b2b with opacity
        ),
        child: Row(
          children: [
            // User Info
            Expanded(
              child: Row(
                children: [
                  // User Profile Picture
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00AAFF),
                        width: 2,
                      ),
                      image:
                          widget.userProfilePic != null
                              ? DecorationImage(
                                image: NetworkImage(widget.userProfilePic!),
                                fit: BoxFit.cover,
                              )
                              : null,
                    ),
                    child:
                        widget.userProfilePic == null
                            ? Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24.w,
                            )
                            : null,
                  ),

                  const SizedBox(width: 15),

                  // User Name and Email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.userName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Rubik',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.userName.toLowerCase().replaceAll(' ', '')}@gmail.com',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Rubik',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // More Options
            GestureDetector(
              onTap: () => _showMoreOptions(),
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(color: Colors.transparent),
                child: Icon(Icons.more_vert, color: Colors.white, size: 24.w),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 138.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: const Color(0x73222B2B), // #322b2b with opacity
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Story Text - positioned at top-left with animation
            if (context.read<StoryCubit>().state.userStories.isNotEmpty &&
                _currentIndex <
                    context.read<StoryCubit>().state.userStories.length)
              AnimationHelper.fadeIn(
                duration: const Duration(milliseconds: 500),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    context
                        .read<StoryCubit>()
                        .state
                        .userStories[_currentIndex]
                        .note,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Rubik',
                    ),
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => Stack(
            children: [
              // Transparent background
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(color: Colors.transparent),
                ),
              ),
              // Bubble menu with triangular pointer - positioned next to three dots
              Positioned(
                top: 60.h, // Positioned right next to the three dots button
                right: 65.w, // Moved left to be next to the three dots
                child: AnimationHelper.fadeIn(
                  duration: const Duration(milliseconds: 300),
                  child: AnimationHelper.slideDown(
                    duration: const Duration(milliseconds: 400),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Triangular pointer pointing to the menu button - positioned to point right
                        Positioned(
                          top:
                              10.h, // Positioned vertically centered on the dialog
                          right:
                              -10.w, // Positioned to extend beyond the right edge
                          child: Container(
                            width: 10.w,
                            height: 20.h,
                            decoration: const BoxDecoration(),
                            child: CustomPaint(
                              size: Size(10.w, 20.h),
                              painter: TrianglePainter(),
                            ),
                          ),
                        ),
                        // Main dialog container
                        Container(
                          width: 135,
                          height: 95,
                          padding: EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Subscribe option with staggered animation
                              AnimationHelper.fadeIn(
                                duration: const Duration(milliseconds: 200),
                                delay: const Duration(milliseconds: 100),
                                child: _buildBubbleOption(
                                  svgPath: 'assets/icons/profile-add.svg',
                                  title: 'Subscribe',
                                  onTap: () {
                                    Navigator.pop(context);
                                    _subscribeToUser();
                                  },
                                ),
                              ),
                              // Report option with staggered animation
                              AnimationHelper.fadeIn(
                                duration: const Duration(milliseconds: 200),
                                delay: const Duration(milliseconds: 200),
                                child: _buildBubbleOption(
                                  svgPath: 'assets/icons/forbidden.svg',
                                  title: 'Report',
                                  onTap: () {
                                    Navigator.pop(context);
                                    _reportUser();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildBubbleOption({
    required String svgPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 32.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            SvgPicture.asset(
              svgPath,
              width: 24.w,
              height: 24.h,
              color: const Color(0xFF354F5C),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF354F5C),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _subscribeToUser() {
    // TODO: Implement subscribe functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Subscribed to user! 👥'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _reportUser() {
    // TODO: Implement report functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User reported! 🚨'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
