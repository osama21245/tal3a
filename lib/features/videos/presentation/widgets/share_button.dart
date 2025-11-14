import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tal3a/core/widgets/app_spaces.dart';
import 'package:tal3a/features/videos/data/model/video_model.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_cubit.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_state.dart';

class ShareButton extends StatefulWidget {
  final VideoModel video;

  const ShareButton({super.key, required this.video});

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton>
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

  Future<void> _onSharePressed() async {
    _controller.forward().then((_) => _controller.reverse());

    await Share.share(widget.video.videoUrl);

    // ignore: use_build_context_synchronously
    context.read<VideoCubit>().incrementShare(widget.video.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<VideoCubit, VideoState>(
          buildWhen: (previous, current) {
            final prevVideo = previous.videos.firstWhere(
              (v) => v.id == widget.video.id,
              orElse: () => widget.video,
            );
            final currVideo = current.videos.firstWhere(
              (v) => v.id == widget.video.id,
              orElse: () => widget.video,
            );
    
            return prevVideo.shares != currVideo.shares;
          },
          builder: (context, state) {
            final latestVideo = state.videos.firstWhere(
              (v) => v.id == widget.video.id,
              orElse: () => widget.video,
            );
            final currentShares = latestVideo.shares;
    
            return Column(
              children: [
                GestureDetector(
                  onTap: _onSharePressed,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: SvgPicture.asset(
                            'assets/icons/share_icon.svg',
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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: Text(
                    currentShares >= 1000
                        ? '${(currentShares / 1000).toStringAsFixed(1)}k'
                        : currentShares.toString(),
                    key: ValueKey<int>(currentShares),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
