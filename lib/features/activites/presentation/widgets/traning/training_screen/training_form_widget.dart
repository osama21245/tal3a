import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tal3a/features/activites/data/models/training_video_series_model.dart';
import 'package:video_player/video_player.dart';
import '../../../../../../core/const/color_pallete.dart';
import '../../../../../../core/const/text_style.dart';
import '../../../../../../core/widgets/primary_button_widget.dart';
import '../../../../../../core/utils/animation_helper.dart';
import '../../../controllers/training_cubit.dart';
import '../../../controllers/tal3a_type_state.dart';

class TrainingFormWidget extends StatefulWidget {
  const TrainingFormWidget({super.key});

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
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();
  }

  void _initializeVideo(String videoUrl) async {
    // Dispose previous controller if exists
    await _videoController?.dispose();
    _videoController?.removeListener(_videoListener);

    setState(() {
      _isVideoInitialized = false;
      _videoLoadError = false;
      _isPlaying = false;
      _isBuffering = true;
      _currentPosition = Duration.zero;
      _totalDuration = Duration.zero;
    });

    try {
      // Create controller - video_player will automatically use HTTP range requests
      // for progressive download if the server supports it
      // This enables chunked streaming like YouTube/Netflix
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        httpHeaders: {'Accept': '*/*'},
      );

      // Add listener before initialization to catch buffering state
      _videoController!.addListener(_videoListener);

      // Initialize asynchronously - this starts downloading in chunks
      // The video will start playing as soon as enough buffer is available
      _videoController!
          .initialize()
          .then((_) {
            if (mounted && _videoController != null) {
              setState(() {
                _isVideoInitialized = true;
                _totalDuration = _videoController!.value.duration;
                _currentPosition = _videoController!.value.position;
                _isBuffering = _videoController!.value.isBuffering;
              });

              // Start playing immediately - player will buffer and play progressively
              // Video starts playing as soon as enough chunks are downloaded
              _videoController!.play();
            }
          })
          .catchError((error) {
            print('Error initializing video: $error');
            if (mounted) {
              setState(() {
                _isVideoInitialized = false;
                _videoLoadError = true;
                _isBuffering = false;
              });
            }
          });
    } catch (e) {
      print('Error creating video controller: $e');
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
          _videoLoadError = true;
          _isBuffering = false;
        });
      }
    }
  }

  void _videoListener() {
    if (_videoController != null && mounted) {
      final value = _videoController!.value;
      setState(() {
        _currentPosition = value.position;
        _isPlaying = value.isPlaying;
        _isBuffering = value.isBuffering;
        _totalDuration = value.duration;

        // Auto-play when buffering completes and video is ready
        if (!_isPlaying &&
            !_isBuffering &&
            _isVideoInitialized &&
            value.duration.inSeconds > 0) {
          _videoController!.play();
        }
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
    final cubit = context.read<TrainingCubit>();
    final state = cubit.state;
    final currentVideo = state.selectedVideo;

    if (currentVideo != null && state.videoSeries.isNotEmpty) {
      // Find current video index
      final currentIndex = state.videoSeries.indexWhere(
        (v) => v.id == currentVideo.id,
      );

      // Go to next video if available
      if (currentIndex >= 0 && currentIndex < state.videoSeries.length - 1) {
        final nextVideo = state.videoSeries[currentIndex + 1];
        cubit.selectVideo(nextVideo);
        _initializeVideo(nextVideo.videoUrl);
      } else {
        // Last video - show completion message or go to home
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have completed all videos!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _goToHome() {
    // Navigate to home screen
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _retryVideo() {
    final cubit = context.read<TrainingCubit>();
    final selectedVideo = cubit.state.selectedVideo;
    if (selectedVideo != null) {
      _initializeVideo(selectedVideo.videoUrl);
    }
  }

  void _onVideoSelected(TrainingVideoSeriesModel video) {
    context.read<TrainingCubit>().selectVideo(video);
    _initializeVideo(video.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingCubit, Tal3aTypeState>(
      builder: (context, state) {
        // Initialize video when selected video changes
        final selectedVideo = state.selectedVideo;
        if (selectedVideo != null &&
            (_videoController == null ||
                _videoController!.dataSource != selectedVideo.videoUrl)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initializeVideo(selectedVideo.videoUrl);
          });
        }

        if (state.isLoading && state.videoSeries.isEmpty) {
          return _buildShimmerTraining();
        }

        if (state.isError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final selectedCoach = state.selectedCoach;
                    final selectedMode = state.selectedMode;
                    if (selectedCoach != null && selectedMode != null) {
                      context.read<TrainingCubit>().loadVideoSeries(
                        coachId: selectedCoach.id,
                        trainingModeId: selectedMode.id,
                      );
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.videoSeries.isEmpty) {
          return const Center(child: Text('No videos found.'));
        }

        final currentVideo = state.selectedVideo ?? state.videoSeries.first;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Player Section with fade-in animation
              AnimationHelper.fadeIn(child: _buildVideoPlayer()),

              const SizedBox(height: 20),

              // Coach Information Section
              AnimationHelper.slideUp(
                child: _buildCoachInfo(state.selectedCoach),
              ),

              const SizedBox(height: 20),

              // Course Information with slide-in animation
              AnimationHelper.slideUp(child: _buildCourseInfo(currentVideo)),

              const SizedBox(height: 20),

              // Training Sessions List with staggered animations
              AnimationHelper.slideUp(
                child: _buildSessionsList(state.videoSeries, currentVideo.id),
              ),

              const SizedBox(height: 30),

              // Action Buttons with fade-in animation
              AnimationHelper.slideUp(child: _buildActionButtons()),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
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
            Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio:
                        _videoController!.value.aspectRatio > 0
                            ? _videoController!.value.aspectRatio
                            : 16 / 9,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
                // Buffering indicator overlay
                if (_isBuffering)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Buffering...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
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

  Widget _buildCoachInfo(CoachData? coach) {
    if (coach == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Coach Image
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorPalette.primaryBlue.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child:
                  coach.imageUrl != null && coach.imageUrl!.isNotEmpty
                      ? Image.network(
                        coach.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[600],
                                size: 35.sp,
                              ),
                            ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      )
                      : Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[600],
                          size: 35.sp,
                        ),
                      ),
            ),
          ),
          SizedBox(width: 16.w),
          // Coach Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coach.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0C2B3B),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  coach.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (coach.bio != null && coach.bio!.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    coach.bio!,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 8.h),
                // Rating
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: ColorPalette.trainingRating,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${coach.rating.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0C2B3B),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '(${coach.totalRatings ?? 0} reviews)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo(TrainingVideoSeriesModel video) {
    return BlocBuilder<TrainingCubit, Tal3aTypeState>(
      builder: (context, state) {
        final selectedCoach = state.selectedCoach;
        final coachRating = selectedCoach?.rating ?? 0.0;
        final coachTotalRatings = selectedCoach?.totalRatings ?? 0;

        // Calculate total duration from all videos
        final totalDurationMinutes =
            state.videoSeries.length * 30; // Estimate 30 min per video
        final hours = totalDurationMinutes ~/ 60;
        final minutes = totalDurationMinutes % 60;
        final durationText =
            hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

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
                      video.title,
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
                        '$coachRating (${coachTotalRatings} reviews)',
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
                        durationText,
                        style: AppTextStyles.trainingDurationStyle,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Rate Coach Button
                  GestureDetector(
                    onTap:
                        () =>
                            _showRatingDialog(context, selectedCoach?.id ?? ''),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorPalette.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorPalette.primaryBlue,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rate,
                            color: ColorPalette.primaryBlue,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Rate',
                            style: TextStyle(
                              color: ColorPalette.primaryBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Description
              Text(
                video.description,
                style: AppTextStyles.trainingDescriptionStyle,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRatingDialog(BuildContext context, String coachId) {
    if (coachId.isEmpty) return;

    // Get cubit before showing dialog to avoid Provider error
    final cubit = context.read<TrainingCubit>();
    int selectedRating = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder:
          (dialogContext) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: StatefulBuilder(
                builder:
                    (context, setDialogState) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'Rate Coach',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0C2B3B),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Share your experience',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Star Rating
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    selectedRating = index + 1;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: Icon(
                                    index < selectedRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: ColorPalette.trainingRating,
                                    size: 48.sp,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Center(
                          child: Text(
                            selectedRating == 1
                                ? 'Poor'
                                : selectedRating == 2
                                ? 'Fair'
                                : selectedRating == 3
                                ? 'Good'
                                : selectedRating == 4
                                ? 'Very Good'
                                : 'Excellent',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorPalette.trainingRating,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Comment Field
                        Text(
                          'Comment (optional)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF0C2B3B),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Write your feedback here...',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14.sp,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: ColorPalette.primaryBlue,
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                          maxLines: 4,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(height: 24.h),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.grey[300]!,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await cubit.rateCoach(
                                      coachId: coachId,
                                      rating: selectedRating,
                                      comment: commentController.text.trim(),
                                    );
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            'Rating submitted successfully!',
                                          ),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error: ${e.toString()}',
                                          ),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorPalette.primaryBlue,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              ),
            ),
          ),
    );
  }

  Widget _buildSessionsList(
    List<TrainingVideoSeriesModel> videos,
    String selectedVideoId,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...videos.asMap().entries.map((entry) {
            final index = entry.key;
            final video = entry.value;
            final isSelected = video.id == selectedVideoId;
            return AnimationHelper.cardAnimation(
              index: index,
              child: _buildSessionItem(video, isSelected),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSessionItem(TrainingVideoSeriesModel video, bool isSelected) {
    // Calculate duration from video (estimate or use actual if available)
    String durationText = '30:00'; // Default estimate
    if (_videoController != null &&
        _videoController!.dataSource == video.videoUrl &&
        _totalDuration.inSeconds > 0) {
      durationText = _formatDuration(_totalDuration);
    }

    return GestureDetector(
      onTap: () => _onVideoSelected(video),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 10.7.h),
        padding: EdgeInsets.symmetric(horizontal: 10.7.w, vertical: 12.8.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? ColorPalette.activityCardSelected
                  : ColorPalette.trainingSessionBg,
          borderRadius: BorderRadius.circular(8.56),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: ColorPalette.activityCardSelected.withOpacity(
                        0.35,
                      ),
                      offset: const Offset(0, 0),
                      blurRadius: 0,
                      spreadRadius: 4,
                    ),
                  ]
                  : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 21.41.w,
              height: 21.41.h,
              child: SvgPicture.asset(
                'assets/icons/play_icon.svg',
                width: 18.w,
                height: 18.h,
                color: isSelected ? Colors.white : const Color(0xFF0C2B3B),
              ),
            ),

            const SizedBox(width: 10.7),

            // Title
            Expanded(
              child: Text(
                video.title,
                style:
                    isSelected
                        ? AppTextStyles.trainingSessionTitleStyle.copyWith(
                          color: Colors.white,
                        )
                        : AppTextStyles.trainingSessionTitleStyle,
              ),
            ),

            // Duration
            Text(
              durationText,
              style:
                  isSelected
                      ? AppTextStyles.trainingSessionDurationStyle.copyWith(
                        color: Colors.white,
                      )
                      : AppTextStyles.trainingSessionDurationStyle,
            ),
          ],
        ),
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

  Widget _buildShimmerTraining() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player Shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 249.6.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Coach Info Shimmer
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                children: [
                  // Coach Image shimmer
                  Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // Coach Info shimmer
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 18.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 120.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 80.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 100.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Course Info Shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and bookmark shimmer
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 25.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Rating and duration shimmer
                  Row(
                    children: [
                      Container(
                        width: 120.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Container(
                        width: 80.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 70.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Description shimmer
                  Container(
                    width: double.infinity,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: 200.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Sessions List Shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: List.generate(3, (index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  period: Duration(milliseconds: 1200 + (index * 200)),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.7.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.7.w,
                      vertical: 12.8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.56),
                    ),
                    child: Row(
                      children: [
                        // Icon shimmer
                        Container(
                          width: 21.41.w,
                          height: 21.41.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: 10.7.w),
                        // Title shimmer
                        Expanded(
                          child: Container(
                            height: 17.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        // Duration shimmer
                        Container(
                          width: 50.w,
                          height: 17.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 30),

          // Action Buttons Shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
