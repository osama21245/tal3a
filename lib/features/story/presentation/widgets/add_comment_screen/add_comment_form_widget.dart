import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../controllers/story_cubit.dart';
import '../../controllers/story_state.dart';
import '../../utils/story_navigation.dart';

class AddCommentFormWidget extends StatefulWidget {
  const AddCommentFormWidget({super.key});

  @override
  State<AddCommentFormWidget> createState() => _AddCommentFormWidgetState();
}

class _AddCommentFormWidgetState extends State<AddCommentFormWidget> {
  final TextEditingController _textController = TextEditingController();
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current story text if exists
    final cubit = context.read<StoryCubit>();
    if (cubit.state.storyText != null) {
      _textController.text = cubit.state.storyText!;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoryCubit, StoryState>(
      listener: (context, state) {
        print(
          '📱 Story upload state changed: isUploaded=${state.isStoryUploaded}, error=${state.uploadError}',
        );

        if (state.isStoryUploaded) {
          print('✅ Story uploaded successfully, navigating to home...');

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Story uploaded successfully! 🎉'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // Navigate to home after a short delay
          Future.delayed(const Duration(seconds: 1), () {
            print('🏠 Navigating to home screen...');
            StoryNavigation.toHome(context);
          });
        } else if (state.uploadError != null) {
          print('❌ Upload failed: ${state.uploadError}');

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload failed: ${state.uploadError}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<StoryCubit, StoryState>(
        builder: (context, state) {
          return Stack(
            children: [
              // Photo Preview Area (Full Screen)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child:
                    state.selectedImagePath != null
                        ? Image.file(
                          File(state.selectedImagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.black,
                              child: const Center(
                                child: Text(
                                  'Error loading image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                        : Container(
                          color: Colors.black,
                          child: const Center(
                            child: Text(
                              'Add Comment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
              ),

              // Top Controls
              Positioned(top: 60, right: 24, child: _buildCloseButton(context)),

              // Emoji Picker (if shown)
              if (_showEmojiPicker)
                Positioned(
                  bottom: 200, // Position above the input area
                  left: 0,
                  right: 0,
                  child: _buildEmojiPicker(context),
                ),

              // Bottom Input Area
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildInputArea(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildEmojiPicker(BuildContext context) {
    final emojis = [
      '😀',
      '😃',
      '😄',
      '😁',
      '😆',
      '😅',
      '🤣',
      '😂',
      '🙂',
      '🙃',
      '😉',
      '😊',
      '😇',
      '🥰',
      '😍',
      '🤩',
      '😘',
      '😗',
      '😚',
      '😙',
      '😋',
      '😛',
      '😜',
      '🤪',
      '😝',
      '🤑',
      '🤗',
      '🤭',
      '🤫',
      '🤔',
      '🤐',
      '🤨',
      '😐',
      '😑',
      '😶',
      '😏',
      '😒',
      '🙄',
      '😬',
      '🤥',
      '😌',
      '😔',
      '😪',
      '🤤',
      '😴',
      '😷',
      '🤒',
      '🤕',
      '🤢',
      '🤮',
      '🤧',
      '🥵',
      '🥶',
      '🥴',
      '😵',
      '🤯',
      '🤠',
      '🥳',
      '😎',
      '🤓',
      '🧐',
      '😕',
      '😟',
      '🙁',
      '☹️',
      '😮',
      '😯',
      '😲',
      '😳',
      '🥺',
      '😦',
      '😧',
      '😨',
      '😰',
      '😥',
      '😢',
      '😭',
      '😱',
      '😖',
      '😣',
      '😞',
      '😓',
      '😩',
      '😫',
      '🥱',
      '😤',
      '😡',
      '😠',
      '🤬',
      '😈',
      '👿',
      '💀',
      '☠️',
      '💩',
      '🤡',
      '👹',
      '👺',
      '👻',
      '👽',
      '👾',
    ];

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE7EAEB), width: 1),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Emojis',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showEmojiPicker = false;
                    });
                  },
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF72848D),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          // Emoji Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: emojis.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    final currentText = _textController.text;
                    final newText = currentText + emojis[index];
                    _textController.text = newText;
                    context.read<StoryCubit>().updateStoryText(newText);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        emojis[index],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, StoryState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Input Container
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                // Top Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: TextField(
                    controller: _textController,
                    onChanged:
                        (text) =>
                            context.read<StoryCubit>().updateStoryText(text),
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      color: Color(0xFF72848D),
                      letterSpacing: 0.48,
                    ),
                    decoration: InputDecoration(
                      hintText: 'story.whats_happening'.tr(),
                      hintStyle: const TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: Color(0xFF72848D),
                        letterSpacing: 0.48,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: null,
                  ),
                ),

                // Bottom Section with Actions
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFFE7EAEB), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Emoji Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showEmojiPicker = !_showEmojiPicker;
                          });
                          // Toggle keyboard
                          if (_showEmojiPicker) {
                            FocusScope.of(context).unfocus();
                          } else {
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          child: Icon(
                            _showEmojiPicker
                                ? Icons.keyboard
                                : Icons.emoji_emotions_outlined,
                            color:
                                _showEmojiPicker
                                    ? const Color(0xFF00AAFF)
                                    : const Color(0xFF72848D),
                            size: 20,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Post Button
                      GestureDetector(
                        onTap:
                            state.isUploadingStory
                                ? null
                                : () => _postStory(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                state.isUploadingStory
                                    ? const Color(0xFF00AAFF).withOpacity(0.6)
                                    : const Color(0xFF00AAFF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child:
                              state.isUploadingStory
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : Text(
                                    'story.post_story'.tr(),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.white,
                                      letterSpacing: 0,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Home Indicator
          const SizedBox(height: 10),
          Container(
            width: 150,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ],
      ),
    );
  }

  void _postStory(BuildContext context) {
    final cubit = context.read<StoryCubit>();
    final state = cubit.state;

    // Check if we have an image and text
    if (state.selectedImagePath != null && _textController.text.isNotEmpty) {
      final imageFile = File(state.selectedImagePath!);
      final note = _textController.text;

      // Upload the story
      cubit.uploadStory(imageFile, note);
    } else {
      // Fallback to local story creation
      cubit.createStory();
      StoryNavigation.replaceWithViewOwnStory(context, cubit);
    }
  }
}
