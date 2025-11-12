import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/camera_cubit.dart';
import '../../controllers/camera_state.dart';
import '../../../data/models/professional_filter.dart';
import '../../utils/story_navigation.dart';
import '../../controllers/story_cubit.dart';
import 'permission_dialog.dart';

class EnhancedCameraPreviewWidget extends StatefulWidget {
  const EnhancedCameraPreviewWidget({super.key});

  @override
  State<EnhancedCameraPreviewWidget> createState() =>
      _EnhancedCameraPreviewWidgetState();
}

class _EnhancedCameraPreviewWidgetState
    extends State<EnhancedCameraPreviewWidget> {
  @override
  void initState() {
    super.initState();
    // Load gallery images by default when camera opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CameraCubit>().loadGalleryImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraCubit, CameraState>(
      listener: (context, state) {
        if (state.error != null) {
          if (state.error!.contains('gallery_permission_denied') ||
              state.error!.contains('Gallery permission denied')) {
            showDialog(
              context: context,
              builder:
                  (context) => PermissionDialog(
                    permissionType: 'photos',
                    onRetry:
                        () => context.read<CameraCubit>().loadGalleryImages(),
                  ),
            );
          }
        }
      },
      builder: (context, state) {
        final cameraCubit = context.read<CameraCubit>();
        final cameraController = cameraCubit.cameraController;

        return Stack(
          children: [
            // Camera Preview or Captured Image
            Positioned.fill(
              child:
                  state.capturedImagePath != null
                      ? _buildCapturedImage(context, state)
                      : _buildLiveCameraPreview(cameraController, state),
            ),

            // Top Controls
            Positioned(
              top: 62,
              right: 24,
              child: _buildFlashButton(context, state),
            ),

            // Close Button
            Positioned(top: 62, left: 24, child: _buildCloseButton(context)),

            // Gallery/Filter Bar with Animation
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child:
                    state.showFilterBar
                        ? _buildFilterBar(context, state)
                        : (state.showGalleryBar &&
                            state.galleryImages.isNotEmpty)
                        ? _buildGalleryBar(context, state)
                        : const SizedBox.shrink(),
              ),
            ),

            // Bottom Controls
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: _buildBottomControls(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLiveCameraPreview(
    CameraController? controller,
    CameraState state,
  ) {
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return ColorFiltered(
      colorFilter:
          ProfessionalFilter.filters[state.selectedFilterIndex].colorFilter ??
          const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
      child: CameraPreview(controller),
    );
  }

  Widget _buildCapturedImage(BuildContext context, CameraState state) {
    return ColorFiltered(
      colorFilter:
          ProfessionalFilter.filters[state.selectedFilterIndex].colorFilter ??
          const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
      child: Image.file(File(state.capturedImagePath!), fit: BoxFit.cover),
    );
  }

  Widget _buildFlashButton(BuildContext context, CameraState state) {
    return GestureDetector(
      onTap: () => context.read<CameraCubit>().toggleFlash(),
      child: SvgPicture.asset(
        'assets/icons/flash_icon.svg',
        width: 40,
        height: 40,
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
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildGalleryBar(BuildContext context, CameraState state) {
    if (state.isLoadingGallery) {
      return Container(
        key: const ValueKey('gallery_loading'),
        height: 98,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return SizedBox(
      key: const ValueKey('gallery_bar'),
      height: 98,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: state.galleryImages.length,
        itemBuilder: (context, index) {
          final asset = state.galleryImages[index];

          return GestureDetector(
            onTap: () => context.read<CameraCubit>().selectGalleryImage(asset),
            child: Container(
              width: 95.375,
              margin: const EdgeInsets.only(right: 15.25),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AssetThumbnail(asset: asset, width: 95, height: 98),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, CameraState state) {
    return SizedBox(
      key: const ValueKey('filter_bar'),
      height: 98,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: ProfessionalFilter.filters.length,
        itemBuilder: (context, index) {
          final filter = ProfessionalFilter.filters[index];
          final isSelected = state.selectedFilterIndex == index;

          return GestureDetector(
            onTap: () => context.read<CameraCubit>().selectFilter(index),
            child: Container(
              width: 95.375,
              margin: const EdgeInsets.only(right: 15.25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(72),
                border:
                    isSelected
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            offset: const Offset(2, 4),
                            blurRadius: 13.3,
                          ),
                        ]
                        : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(72),
                child: _buildFilterPreview(filter, state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterPreview(ProfessionalFilter filter, CameraState state) {
    // Use captured image if available, otherwise show a placeholder
    if (state.capturedImagePath != null) {
      return ColorFiltered(
        colorFilter:
            filter.colorFilter ??
            const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
        child: Image.file(File(state.capturedImagePath!), fit: BoxFit.cover),
      );
    } else {
      // Show filter preview with emoji and name
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[300]!, Colors.grey[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ColorFiltered(
          colorFilter:
              filter.colorFilter ??
              const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(filter.emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(
                    filter.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildBottomControls(BuildContext context, CameraState state) {
    if (state.capturedImagePath != null) {
      return _buildCapturedImageControls(context);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Emoji Button (Filter Toggle)
        _buildEmojiButton(context, state),

        // Capture Button
        _buildCaptureButton(context, state),

        // Camera Reverse Button
        _buildCameraReverseButton(context),
      ],
    );
  }

  Widget _buildEmojiButton(BuildContext context, CameraState state) {
    return GestureDetector(
      onTap: () => context.read<CameraCubit>().toggleFilterBar(),
      child: SvgPicture.asset(
        'assets/icons/emoji_icon.svg',
        width: 50,
        height: 50,
      ),
    );
  }

  Widget _buildCaptureButton(BuildContext context, CameraState state) {
    return GestureDetector(
      onTap:
          state.isCapturing
              ? null
              : () => context.read<CameraCubit>().capturePhoto(),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.25),
        ),
        child: Center(
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.25),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraReverseButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<CameraCubit>().switchCamera(),
      child: SvgPicture.asset(
        'assets/icons/camera_reverse_icon.svg',
        width: 40,
        height: 40,
      ),
    );
  }

  Widget _buildCapturedImageControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Retake Button
          GestureDetector(
            onTap: () => context.read<CameraCubit>().clearCapturedImage(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'story.retake_photo'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Use Photo Button
          GestureDetector(
            onTap: () => _navigateToNextScreen(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF00AAFF),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'story.use_photo'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    final cameraState = context.read<CameraCubit>().state;
    final storyCubit = context.read<StoryCubit>();

    // Transfer image path to story cubit
    if (cameraState.capturedImagePath != null) {
      storyCubit.selectImage(cameraState.capturedImagePath!);
      storyCubit.selectFilter(
        storyCubit.state.filters[cameraState.selectedFilterIndex],
      );

      // Navigate to add comment screen
      StoryNavigation.toAddComment(context, storyCubit);
    }
  }
}

// Helper widget for displaying asset thumbnails
class AssetThumbnail extends StatelessWidget {
  final AssetEntity asset;
  final int width;
  final int height;

  const AssetThumbnail({
    super.key,
    required this.asset,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: asset.thumbnailDataWithSize(ThumbnailSize(width, height)).then((
        data,
      ) async {
        if (data != null) {
          final tempDir = Directory.systemTemp;
          final file = File('${tempDir.path}/thumb_${asset.id}.jpg');
          await file.writeAsBytes(data);
          return file;
        }
        return null;
      }),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            snapshot.data!,
            width: width.toDouble(),
            height: height.toDouble(),
            fit: BoxFit.cover,
          );
        }
        return Container(
          width: width.toDouble(),
          height: height.toDouble(),
          color: Colors.grey[300],
          child: const Icon(Icons.image, color: Colors.grey),
        );
      },
    );
  }
}
