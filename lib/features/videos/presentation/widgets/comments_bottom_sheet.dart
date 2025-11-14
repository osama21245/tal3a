import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/controller/user_controller.dart';
import 'package:tal3a/features/videos/data/model/video_model.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_cubit.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_state.dart';

class CommentsBottomSheet extends StatefulWidget {
  final VideoModel video;
  const CommentsBottomSheet({super.key, required this.video});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<VideoCubit>().loadComments(videoId: widget.video.id);
    });

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );

    _animController.forward();
  }

  @override
  void dispose() {
    if (mounted) {
      _controller.dispose();
      _animController.dispose();
    }
    super.dispose();
  }

  void _closeSheet() {
    if (!_animController.isAnimating) {
      _animController.reverse().then((_) {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final user = context.watch<UserController>().state.user;

    return Stack(
      children: [
        GestureDetector(
          onTap: _closeSheet,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
        ),

        AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(bottom: bottom),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF121212),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // drag handle
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const Text(
                        "Comments",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Flexible(
                        child: BlocBuilder<VideoCubit, VideoState>(
                          builder: (context, state) {
                          final allComments = state.comments;


                            if (state.isLoadingComments) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                  strokeWidth: 2,
                                ),
                              );
                            }

                            if (state.isError && state.comments.isEmpty) {
                              return Center(
                                child: Text(
                                  state.error ?? "Something went wrong",
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              );
                            }

                            if (allComments.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No comments yet. Be the first!",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              itemCount: allComments.length,
                              itemBuilder: (context, index) {
                                final comment = allComments[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E1E1E),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 18,
                                      backgroundImage:
                                          (comment.userImageUrl.isNotEmpty &&
                                                  comment.userImageUrl
                                                      .startsWith("http"))
                                              ? NetworkImage(
                                                comment.userImageUrl,
                                              )
                                              : null,
                                      child:
                                          (comment.userImageUrl.isEmpty ||
                                                  !comment.userImageUrl
                                                      .startsWith("http"))
                                              ? const Icon(
                                                Icons.person,
                                                size: 18,
                                                color: Colors.white54,
                                              )
                                              : null,
                                    ),
                                    title: Text(
                                      comment.userName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      comment.text,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                    trailing:
                                        comment.isPending
                                            ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.blueAccent,
                                              ),
                                            )
                                            : IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.white54,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                context
                                                    .read<VideoCubit>()
                                                    .deleteComment(
                                                      commentId: comment.id,
                                                    );
                                              },
                                            ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      SafeArea(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF181818),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Add a comment...",
                                    hintStyle: const TextStyle(
                                      color: Colors.white54,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF2A2A2A),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  final text = _controller.text.trim();
                                  if (text.isEmpty || user == null) return;

                                  context.read<VideoCubit>().postComment(
                                    videoId: widget.video.id,
                                    text: text,
                                    user: user,
                                  );

                                  _controller.clear();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        ColorPalette.primaryBlue,
                                        Colors.purpleAccent,
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
