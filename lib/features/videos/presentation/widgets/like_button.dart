import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/features/videos/data/model/video_model.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_cubit.dart';

class LikeButton extends StatefulWidget {
  final VideoModel video;

  const LikeButton({super.key, required this.video});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>with SingleTickerProviderStateMixin {
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _colorAnimation = ColorTween(
      begin: ColorPalette.white,
      end: Colors.red,
    ).animate(_controller);
  }

  void _onLikePressed() {
    _controller.forward().then((_) => _controller.reverse());
    context.read<VideoCubit>().toggleLike(widget.video.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    return Positioned(
      left: 16,
      bottom: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _onLikePressed,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Icon(
                    video.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: video.isLiked
                        ? Colors.red
                        : _colorAnimation.value ?? Colors.white,
                    size: 32,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(video.likes / 1000).toStringAsFixed(1)}k',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.chat_bubble_outline,
              color: Colors.white, size: 30),
          const SizedBox(height: 20),
          const Icon(Icons.send, color: Colors.white, size: 30),
          Text('${(video.shares / 1000).toStringAsFixed(1)}k',
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
