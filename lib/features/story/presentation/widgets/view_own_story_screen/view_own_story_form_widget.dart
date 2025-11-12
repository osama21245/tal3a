import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../controllers/story_cubit.dart';
import '../../controllers/story_state.dart';
import '../../utils/story_navigation.dart';

class ViewOwnStoryFormWidget extends StatefulWidget {
  const ViewOwnStoryFormWidget({super.key});

  @override
  State<ViewOwnStoryFormWidget> createState() => _ViewOwnStoryFormWidgetState();
}

class _ViewOwnStoryFormWidgetState extends State<ViewOwnStoryFormWidget> {
  bool _showActionMenu = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, state) {
        final currentStory =
            state.stories.isNotEmpty ? state.stories.first : null;

        return Stack(
          children: [
            // Story Preview Area (Full Screen)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child:
                  currentStory?.imageUrl != null
                      ? Image.asset(currentStory!.imageUrl!, fit: BoxFit.cover)
                      : Container(
                        color: Colors.black,
                        child: const Center(
                          child: Text(
                            'My Story',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
            ),

            // Top Controls
            Positioned(top: 60, right: 24, child: _buildMoreButton(context)),

            // Story Text Overlay
            if (currentStory?.text != null && currentStory!.text!.isNotEmpty)
              Positioned(
                bottom: 120,
                left: 20,
                right: 20,
                child: _buildStoryTextOverlay(currentStory.text!),
              ),

            // Action Menu
            if (_showActionMenu)
              Positioned(
                top: 90,
                right: 24,
                child: _buildActionMenu(context, state),
              ),

            // Home Indicator
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 150,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showActionMenu = !_showActionMenu;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.more_vert, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildStoryTextOverlay(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF322B2B).withOpacity(0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.white,
          letterSpacing: 0.48,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context, StoryState state) {
    return Container(
      width: 135,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionMenuItem(
            context,
            'story.delete'.tr(),
            Icons.delete_outline,
            () => _deleteStory(context),
          ),
          _buildActionMenuItem(
            context,
            'story.share'.tr(),
            Icons.share_outlined,
            () => _shareStory(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showActionMenu = false;
        });
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              child: Icon(icon, color: const Color(0xFF354F5C), size: 20),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF354F5C),
                letterSpacing: 0.07,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteStory(BuildContext context) {
    final cubit = context.read<StoryCubit>();
    if (cubit.state.stories.isNotEmpty) {
      cubit.deleteStory(cubit.state.stories.first.id);

      // Navigate back to previous screen
      StoryNavigation.pop(context);
    }
  }

  void _shareStory(BuildContext context) {
    final cubit = context.read<StoryCubit>();
    if (cubit.state.stories.isNotEmpty) {
      cubit.shareStory(cubit.state.stories.first.id);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('story.story_shared'.tr()),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
