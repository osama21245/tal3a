import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/const/text_style.dart';
import '../controllers/story_cubit.dart';
import '../controllers/story_state.dart';
import '../utils/story_navigation.dart';

class StoryMainScreen extends StatelessWidget {
  const StoryMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoryCubit()..loadStories(),
      child: Scaffold(
        backgroundColor: ColorPalette.white,
        appBar: AppBar(
          title: Text('story.add_story'.tr(), style: AppTextStyles.titleStyle),
          backgroundColor: ColorPalette.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: BlocBuilder<StoryCubit, StoryState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add Story Button
                  _buildAddStoryButton(context),

                  const SizedBox(height: 30),

                  // Stories Section
                  Text('story.my_story'.tr(), style: AppTextStyles.titleStyle),

                  const SizedBox(height: 20),

                  // Stories List
                  Expanded(
                    child:
                        state.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : state.stories.isEmpty
                            ? _buildEmptyState()
                            : _buildStoriesList(context, state),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddStoryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => _navigateToCamera(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              'story.add_story'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'story.no_stories'.tr(),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesList(BuildContext context, StoryState state) {
    return ListView.builder(
      itemCount: state.stories.length + 1, // +1 for "View Others" button
      itemBuilder: (context, index) {
        if (index == state.stories.length) {
          return _buildViewOthersButton(context);
        }

        final story = state.stories[index];
        return _buildStoryCard(context, story);
      },
    );
  }

  Widget _buildStoryCard(BuildContext context, dynamic story) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 60,
            height: 60,
            child:
                story.imageUrl != null
                    ? Image.asset(story.imageUrl, fit: BoxFit.cover)
                    : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image),
                    ),
          ),
        ),
        title: Text(
          story.text ?? 'story.my_story'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          _formatDate(story.createdAt),
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.visibility, color: Colors.grey[600], size: 16),
            const SizedBox(width: 4),
            Text(
              '${story.viewCount}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        onTap: () => _navigateToViewOwnStory(context),
      ),
    );
  }

  Widget _buildViewOthersButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: OutlinedButton(
          onPressed: () => _navigateToViewOthersStory(context),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: ColorPalette.primaryBlue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                color: ColorPalette.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'story.others_story'.tr(),
                style: TextStyle(
                  color: ColorPalette.primaryBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _navigateToCamera(BuildContext context) {
    StoryNavigation.toCamera(context, context.read<StoryCubit>());
  }

  void _navigateToViewOwnStory(BuildContext context) {
    StoryNavigation.toViewOwnStory(context, context.read<StoryCubit>());
  }

  void _navigateToViewOthersStory(BuildContext context) {
    StoryNavigation.toViewOthersStory(context, context.read<StoryCubit>());
  }
}
