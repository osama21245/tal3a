import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tal3a/features/activites/data/models/training_course_model.dart';
import 'package:video_player/video_player.dart';
import '../../../../../../core/const/color_pallete.dart';
import '../../../../../../core/const/text_style.dart';
import '../../../../../../core/widgets/primary_button_widget.dart';
import '../../../../../../core/utils/animation_helper.dart';

class TrainingFormWidget extends StatefulWidget {
  final String? selectedTal3aType;
  final String? selectedCoach;
  final String? selectedMode;

  const TrainingFormWidget({
    super.key,
    this.selectedTal3aType,
    this.selectedCoach,
    this.selectedMode,
  });

  @override
  State<TrainingFormWidget> createState() => _TrainingFormWidgetState();
}

class _TrainingFormWidgetState extends State<TrainingFormWidget> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _isBookmarked = false;
  bool _isFullscreen = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _videoLoadError = false;

  // Sample data - this will come from backend
  late TrainingCourseModel _course;

  @override
  void initState() {
    super.initState();
    _initializeCourse();
    _initializeVideo();
  }

  void _initializeCourse() {
    _course = TrainingCourseModel(
      id: '1',
      title: 'Personal Trainer',
      description:
          'You will learn how to put together professional training plans to apply to specific goals of your own or those you will train in the future.',
      rating: 4.9,
      reviewCount: 231,
      duration: '5h 30m',
      thumbnailUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      videoUrl:
          'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      sessions: [
        TrainingSessionModel(
          id: '1',
          title: 'Introduction',
          duration: '13:02',
          isUnlocked: true,
          isCompleted: false,
        ),
        TrainingSessionModel(
          id: '2',
          title: 'First steps',
          duration: '21:39',
          isUnlocked: false,
          isCompleted: false,
        ),
        TrainingSessionModel(
          id: '3',
          title: 'Mental preparation',
          duration: '21:39',
          isUnlocked: false,
          isCompleted: false,
        ),
        TrainingSessionModel(
          id: '4',
          title: 'Tactics',
          duration: '21:39',
          isUnlocked: false,
          isCompleted: false,
        ),
      ],
      isBookmarked: false,
    );
  }

  void _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(_course.videoUrl),
      );
      await _videoController!.initialize();

      _videoController!.addListener(_videoListener);

      setState(() {
        _isVideoInitialized = true;
        _totalDuration = _videoController!.value.duration;
        _currentPosition = _videoController!.value.position;
      });
    } catch (e) {
      print('Error initializing video: $e');
      // Try alternative video URL
      try {
        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(
            'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
          ),
        );
        await _videoController!.initialize();
        _videoController!.addListener(_videoListener);
        setState(() {
          _isVideoInitialized = true;
          _totalDuration = _videoController!.value.duration;
          _currentPosition = _videoController!.value.position;
        });
      } catch (e2) {
        print('Error with alternative video: $e2');
        setState(() {
          _isVideoInitialized = false;
          _videoLoadError = true;
        });
      }
    }
  }

  void _videoListener() {
    if (_videoController != null) {
      setState(() {
        _currentPosition = _videoController!.value.position;
        _isPlaying = _videoController!.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoController != null) {
      if (_isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoController?.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _seekTo(Duration position) {
    _videoController?.seekTo(position);
  }

  void _seekForward() {
    final newPosition = _currentPosition + const Duration(seconds: 10);
    if (newPosition <= _totalDuration) {
      _seekTo(newPosition);
    }
  }

  void _seekBackward() {
    final newPosition = _currentPosition - const Duration(seconds: 10);
    if (newPosition >= Duration.zero) {
      _seekTo(newPosition);
    }
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  void _continueTraining() {
    // Navigate to next session or complete training
    print('Continue training');
  }

  void _goToHome() {
    // Navigate to home screen
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _retryVideo() {
    setState(() {
      _videoLoadError = false;
      _isVideoInitialized = false;
    });
    _initializeVideo();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player Section with fade-in animation
          AnimationHelper.fadeIn(child: _buildVideoPlayer()),

          const SizedBox(height: 20),

          // Course Information with slide-in animation
          AnimationHelper.slideUp(child: _buildCourseInfo()),

          const SizedBox(height: 20),

          // Training Sessions List with staggered animations
          AnimationHelper.slideUp(child: _buildSessionsList()),

          const SizedBox(height: 30),

          // Action Buttons with fade-in animation
          AnimationHelper.slideUp(child: _buildActionButtons()),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      height: 249.6.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Stack(
        children: [
          // Video Player
          if (_isVideoInitialized && _videoController != null)
            Center(
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            )
          else if (_videoLoadError)
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.white, size: 48.sp),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load video',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check your internet connection',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retryVideo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      'Loading video...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Video Controls
          _buildVideoControls(),
        ],
      ),
    );
  }

  Widget _buildVideoControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 124.8.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xFF000000)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Time display
              Text(
                '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                style: AppTextStyles.videoTimeStyle,
              ),

              const SizedBox(height: 8),

              // Progress bar
              _buildProgressBar(),

              const SizedBox(height: 20),

              // Controls row
              Row(
                children: [
                  // Seek backward
                  GestureDetector(
                    onTap: _seekBackward,
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      child: const Icon(
                        Icons.replay_10,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Play/Pause
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Seek forward
                  GestureDetector(
                    onTap: _seekForward,
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      child: const Icon(
                        Icons.forward_10,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Volume
                  GestureDetector(
                    onTap: _toggleMute,
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Fullscreen
                  GestureDetector(
                    onTap: _toggleFullscreen,
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      child: const Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress =
        _totalDuration.inMilliseconds > 0
            ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
            : 0.0;

    return GestureDetector(
      onTapDown: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        final progressValue = localPosition.dx / box.size.width;
        final newPosition = Duration(
          milliseconds: (progressValue * _totalDuration.inMilliseconds).round(),
        );
        _seekTo(newPosition);
      },
      child: Container(
        height: 4.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Stack(
          children: [
            // Progress
            Container(
              width: MediaQuery.of(context).size.width * progress,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Progress Handle
            Positioned(
              left: (MediaQuery.of(context).size.width * progress) - 6.w,
              top: -4.h,
              child: Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
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

  Widget _buildCourseInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Bookmark
          Row(
            children: [
              Expanded(
                child: Text(
                  _course.title,
                  style: AppTextStyles.trainingCourseTitleStyle,
                ),
              ),
              GestureDetector(
                onTap: _toggleBookmark,
                child: Container(
                  width: 24.w,
                  height: 24.h,
                  child: Icon(
                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: ColorPalette.trainingBookmark,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Rating and Duration
          Row(
            children: [
              // Rating
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: ColorPalette.trainingRating,
                    size: 17.13,
                  ),
                  const SizedBox(width: 4.28),
                  Text(
                    '${_course.rating} (${_course.reviewCount} reviews)',
                    style: AppTextStyles.trainingRatingStyle,
                  ),
                ],
              ),

              const SizedBox(width: 15),

              // Duration
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: ColorPalette.trainingSessionLocked,
                    size: 17.13,
                  ),
                  const SizedBox(width: 4.28),
                  Text(
                    _course.duration,
                    style: AppTextStyles.trainingDurationStyle,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Description
          Text(
            _course.description,
            style: AppTextStyles.trainingDescriptionStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._course.sessions.asMap().entries.map((entry) {
            final index = entry.key;
            final session = entry.value;
            return AnimationHelper.cardAnimation(
              index: index,
              child: _buildSessionItem(session),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSessionItem(TrainingSessionModel session) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 10.7.h),
      padding: EdgeInsets.symmetric(horizontal: 10.7.w, vertical: 12.8.h),
      decoration: BoxDecoration(
        color: ColorPalette.trainingSessionBg,
        borderRadius: BorderRadius.circular(8.56),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 21.41.w,
            height: 21.41.h,
            child:
                session.isUnlocked
                    ? SvgPicture.asset(
                      'assets/icons/play_icon.svg',
                      width: 18.w,
                      height: 18.h,
                      color: Color(0xFF0C2B3B),
                    )
                    : SvgPicture.asset(
                      'assets/icons/lock_icon.svg',
                      width: 16.w,
                      height: 18.h,
                      color: Color(0xFF0C2B3B),
                    ),
          ),

          const SizedBox(width: 10.7),

          // Title
          Expanded(
            child: Text(
              session.title,
              style:
                  session.isUnlocked
                      ? AppTextStyles.trainingSessionTitleStyle
                      : AppTextStyles.trainingSessionTitleLockedStyle,
            ),
          ),

          // Duration
          Text(
            session.duration,
            style:
                session.isUnlocked
                    ? AppTextStyles.trainingSessionDurationStyle
                    : AppTextStyles.trainingSessionDurationLockedStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          // Continue Button
          Expanded(
            child: PrimaryButtonWidget(
              text: 'Continue',
              onPressed: _continueTraining,
              isEnabled: true,
            ),
          ),

          const SizedBox(width: 20),

          // Go to Home Button
          Expanded(
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorPalette.goToHomeButtonBorder,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextButton(
                onPressed: _goToHome,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'go to home',
                  style: AppTextStyles.goToHomeButtonStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
