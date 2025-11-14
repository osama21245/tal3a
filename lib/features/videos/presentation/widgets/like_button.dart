import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/features/videos/data/model/video_model.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_cubit.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_state.dart';

class LikeButton extends StatefulWidget {
  final VideoModel video;
  const LikeButton({super.key, required this.video});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _colorAnimation = ColorTween(
      begin: ColorPalette.white,
      end: Colors.red,
    ).animate(_controller);
  }

  void _onLikePressed(String videoId) {
    _controller.forward().then((_) => _controller.reverse());
    context.read<VideoCubit>().toggleLike(videoId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      buildWhen: (previous, current) {
        final prevVideo = previous.videos.firstWhere(
          (v) => v.id == widget.video.id,
          orElse: () => widget.video,
        );
        final currVideo = current.videos.firstWhere(
          (v) => v.id == widget.video.id,
          orElse: () => widget.video,
        );
        return prevVideo.likes != currVideo.likes ||
            prevVideo.isLiked != currVideo.isLiked;
      },
      builder: (context, state) {
        final latestVideo = state.videos.firstWhere(
          (v) => v.id == widget.video.id,
          orElse: () => widget.video,
        );


        final isLiked = latestVideo.isLiked;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _onLikePressed(latestVideo.id),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: SvgPicture.asset(
                      'assets/icons/like_icon.svg',
                      color:
                          isLiked
                              ? Colors.red
                              : _colorAnimation.value ?? Colors.white,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
              child: Text(
                latestVideo.likes >= 1000
                    ? '${(latestVideo.likes / 1000).toStringAsFixed(1)}k'
                    : latestVideo.likes.toString(),
                key: ValueKey<int>(latestVideo.likes),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
