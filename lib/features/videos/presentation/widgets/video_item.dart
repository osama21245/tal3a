import 'package:flutter/material.dart';
import 'package:tal3a/features/videos/presentation/widgets/like_button.dart';
import 'package:video_player/video_player.dart';
import '../../data/model/video_model.dart';

class ReelItem extends StatelessWidget {
  final VideoModel video;
  final VideoPlayerController controller;
  final VoidCallback onLikePressed;
  final VoidCallback onFollowPressed;

  const ReelItem({
    super.key,
    required this.video,
    required this.controller,
    required this.onLikePressed,
    required this.onFollowPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        controller.value.isInitialized
            ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              )
            : const Center(child: CircularProgressIndicator()),

        Positioned(
          left: 16,
          bottom: 300,
          child: Column(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(video.userImageUrl),
              ),
              const SizedBox(height: 4),
              if (!video.isFollowed)
                GestureDetector(
                  onTap: onFollowPressed,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration:  BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
            ],
          ),
        ),
        LikeButton(video: video,),

        Positioned(
          left: 16,
          bottom: 40,
          right: 16,
          child: Text(
            video.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              shadows: [Shadow(color: Colors.black, blurRadius: 3)],
            ),
          ),
        ),

        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: VideoProgressIndicator(
            controller,
            allowScrubbing: false,
            colors: const VideoProgressColors(
              playedColor: Colors.blueAccent,
              backgroundColor: Colors.white24,
              bufferedColor: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }
}
