import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_cubit.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_state.dart';
import 'package:tal3a/features/videos/presentation/widgets/video_item.dart';
import 'package:video_player/video_player.dart';
import '../../data/model/video_model.dart';

class VideoShow extends StatefulWidget {
  const VideoShow({super.key});

  @override
  State<VideoShow> createState() => _VideoShowState();
}

class _VideoShowState extends State<VideoShow> {
  final PageController _pageController = PageController();
  final List<VideoPlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    context.read<VideoCubit>().loadVideos();
  }

  void _initializeControllers(List<VideoModel> videos) {
    if (_controllers.isNotEmpty) return;

    for (var video in videos) {
      final controller = VideoPlayerController.networkUrl(
          Uri.parse(video.videoUrl),
        )
        ..initialize().then((_) {
          setState(() {});
        });

      _controllers.add(controller);
    }
    if (_controllers.isNotEmpty) _controllers.first.play();
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: _buildShimmerVideos());
        }

        if (state.isError) {
          return Center(child: Text('Error: >>> ${state.error}'));
        }

        final videos = state.videos;
        if (videos.isEmpty) {
          return const Center(child: Text('No videos found'));
        }

        _initializeControllers(videos);

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: videos.length,
          onPageChanged: (index) {
            for (var c in _controllers) {
              c.pause();
            }
            _controllers[index].play();
          },
          itemBuilder: (context, index) {
            final video = videos[index];
            final controller = _controllers[index];

            return ReelItem(
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

  Widget _buildShimmerVideos() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: ColorPalette.white,
      highlightColor: Colors.grey[100]!,
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
                // ignore: deprecated_member_use
                color: Colors.grey[200]!.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  
  }
}
