import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/widgets/app_spaces.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_cubit.dart';
import 'package:tal3a/features/videos/presentation/widgets/comment_button.dart';

import 'package:tal3a/features/videos/presentation/widgets/like_button.dart';

import 'package:tal3a/features/videos/presentation/widgets/share_button.dart';
import 'package:tal3a/features/videos/presentation/widgets/user_follow_profile.dart';
import 'package:tal3a/features/videos/presentation/widgets/video_options_popup.dart';
import 'package:video_player/video_player.dart';
import '../../data/model/video_model.dart';

class VideoItem extends StatelessWidget {
  final VideoModel video;
  final VideoPlayerController controller;
  final VoidCallback onLikePressed;
  final VoidCallback onFollowPressed;

  const VideoItem({
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
          top: 40,
          right: 16,
          child: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                barrierColor: Colors.transparent,
                barrierDismissible: true,
                builder: (_) {
                  return BlocProvider.value(
                    value: context.read<VideoCubit>(),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(color: Colors.transparent),
                          ),
                        ),

                        Positioned(
                          top: kToolbarHeight + 8,
                          right: 16,
                          child: VideoOptionsPopup(video: video),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),

        Positioned(
          left: 16,
          bottom: 100,
          right: 16,
          child: Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserFollowProfile(video: video, onFollowPressed: onFollowPressed),
              AppSpaces.horizontalSpace(10),

              LikeButton(video: video),
              CommentButton(video: video),
              ShareButton(video: video),

              Text(
                video.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                ),
              ),
            ],
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
              playedColor: ColorPalette.primaryBlue,
              backgroundColor: Colors.white,
              bufferedColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
