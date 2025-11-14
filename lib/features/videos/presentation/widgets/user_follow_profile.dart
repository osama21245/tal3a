import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tal3a/features/videos/data/model/video_model.dart';

class UserFollowProfile extends StatelessWidget {
  const UserFollowProfile({
    super.key,
    required this.video,
    required this.onFollowPressed,
  });

  final VideoModel video;
  final VoidCallback onFollowPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage(video.userImageUrl),
        ),
        if (!video.isFollowed)
          Positioned(
            bottom: -4,
            right: -6,
            child: GestureDetector(
              onTap: onFollowPressed,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset("assets/icons/follow_icon.svg"),
              ),
            ),
          ),
      ],
    );
  }
}