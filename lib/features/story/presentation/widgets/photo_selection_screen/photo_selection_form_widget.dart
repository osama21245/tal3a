import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllers/story_cubit.dart';
import '../../controllers/story_state.dart';
import '../../utils/story_navigation.dart';

class PhotoSelectionFormWidget extends StatelessWidget {
  const PhotoSelectionFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
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
                      ? Image.asset(state.selectedImagePath!, fit: BoxFit.cover)
                      : Container(
                        color: Colors.black,
                        child: const Center(
                          child: Text(
                            'Select Photo',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
            ),

            // Top Controls
            Positioned(top: 60, right: 24, child: _buildCloseButton(context)),

            // Bottom Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomControls(context, state),
            ),

            // Gallery Thumbnails
            Positioned(
              bottom: 130,
              left: 20,
              right: 20,
              child: _buildGalleryThumbnails(context, state),
            ),
          ],
        );
      },
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

  Widget _buildBottomControls(BuildContext context, StoryState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Gallery Button
          GestureDetector(
            onTap: () => _openGallery(context),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.photo_library_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          // Use Photo Button
          GestureDetector(
            onTap: () => _usePhoto(context),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 4,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(11),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Switch Camera Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.cameraswitch,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryThumbnails(BuildContext context, StoryState state) {
    final mockPhotos = [
      'assets/images/fitness_partner.png',
      'assets/images/friends_step.png',
      'assets/images/certified_coaches.png',
      'assets/images/male_runner.png',
      'assets/images/female_runner.png',
    ];

    return Container(
      height: 98,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mockPhotos.length,
        itemBuilder: (context, index) {
          final photoPath = mockPhotos[index];
          return _buildThumbnailItem(context, photoPath, index);
        },
      ),
    );
  }

  Widget _buildThumbnailItem(
    BuildContext context,
    String photoPath,
    int index,
  ) {
    return GestureDetector(
      onTap: () => context.read<StoryCubit>().selectImage(photoPath),
      child: Container(
        width: 95.375,
        height: 98,
        margin: EdgeInsets.only(right: index == 0 ? 15.25 : 15.25),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(photoPath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) {
    // TODO: Implement gallery opening functionality
    print('Opening gallery...');
  }

  void _usePhoto(BuildContext context) {
    final cubit = context.read<StoryCubit>();
    if (cubit.state.selectedImagePath != null) {
      StoryNavigation.toAddComment(context, cubit);
    }
  }
}
