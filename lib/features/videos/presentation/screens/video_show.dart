import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_cubit.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_state.dart';
import 'package:tal3a/features/videos/presentation/widgets/video_item.dart';
import 'package:video_player/video_player.dart';
import '../../data/model/video_model.dart';

class VideoShow extends StatefulWidget {
  final PageController? pageController;

  const VideoShow({super.key, this.pageController});

  @override
  State<VideoShow> createState() => _VideoShowState();
}

class _VideoShowState extends State<VideoShow> {
  late final PageController _pageController;
  final List<VideoPlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _pageController = widget.pageController ?? PageController();
  }

  void _initializeControllers(List<VideoModel> videos) {
    if (_controllers.isNotEmpty) return;
    for (var video in videos) {
      final controller = VideoPlayerController.networkUrl(
          Uri.parse(video.videoUrl),
        )
        ..initialize().then((_) {
          setState(() {});
          if (!video.hasViewed) {
            // ignore: use_build_context_synchronously
            context.read<VideoCubit>().incrementView(video.id);
          }
        });
      _controllers.add(controller);
    }
    if (_controllers.isNotEmpty) {
      _controllers.first.play();
      if (!videos.first.hasViewed) {
        context.read<VideoCubit>().incrementView(videos.first.id);
      }
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    if (widget.pageController == null) _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
        if (state.isLoading) return Center(child: _buildShimmerVideos(5));
        if (state.isError) return Center(child: Text('Error: ${state.error}'));
        if (state.videos.isEmpty) {
          return const Center(child: Text('No videos found'));
        }

        _initializeControllers(state.videos);

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: state.videos.length,
          onPageChanged: (index) {
            for (var c in _controllers) {
              c.pause();
            }
            _controllers[index].play();
            final video = state.videos[index];
            if (!video.hasViewed) {
              context.read<VideoCubit>().incrementView(video.id);
            }
            if (index == state.videos.length - 1) {
              context.read<VideoCubit>().loadVideos(isLoadMore: true);
            }
          },
          itemBuilder: (context, index) {
            final video = state.videos[index];
            final controller = _controllers[index];
            return VideoItem(
              video: video,
              controller: controller,
              onLikePressed:
                  () => context.read<VideoCubit>().toggleLike(video.id),
              onFollowPressed:
                  () => context.read<VideoCubit>().toggleFollow(video.id),
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerVideos(int index) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.12),
      highlightColor: Colors.white.withOpacity(0.9),
      period: Duration(milliseconds: 1000 + (index * 200)),
      child: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.grey[300],
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 80,
                color: Colors.grey[400],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Container(
                height: 100,
                color: Colors.grey[200]!.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
