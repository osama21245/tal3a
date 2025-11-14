import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tal3a/core/widgets/app_spaces.dart';
import 'package:tal3a/features/videos/data/model/video_model.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_cubit.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_state.dart';
import 'comments_bottom_sheet.dart';

class CommentButton extends StatefulWidget {
  final VideoModel video;
  const CommentButton({super.key, required this.video});
  
  @override
  State<CommentButton> createState() => _CommentButtonState();
}
  
class _CommentButtonState extends State<CommentButton>
  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  
    _fadeAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }
  
  void _onCommentPressed() {
    _controller.forward().then((_) => _controller.reverse());
  
    context.read<VideoCubit>().loadComments(videoId: widget.video.id);
  
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<VideoCubit>(),
          child: CommentsBottomSheet(video: widget.video),
        );
      },
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _onCommentPressed,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: SvgPicture.asset(
                        "assets/icons/comment_icon.svg",
                        color: Colors.white,
                        height: 30,
                        width: 30,
                      ),
                    ),
                  );
                },
              ),
            ),
            AppSpaces.horizontalSpace(10),
        
          ],
        );
      },
    );
  }
} 
