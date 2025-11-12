import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../controllers/camera_cubit.dart';
import '../../controllers/camera_state.dart';
import '../../../data/models/photo_filter.dart';
import '../../utils/story_navigation.dart';
import '../../controllers/story_cubit.dart';

class LiveCameraPreviewWidget extends StatelessWidget {
  const LiveCameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
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

            // Filter Strip
            if (state.capturedImagePath != null)
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: _buildFilterStrip(context, state),
              ),

            // Bottom Controls
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: _buildBottomControls(context, state),
            ),

            // Home Indicator
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: _buildHomeIndicator(),
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
          PhotoFilter.filters[state.selectedFilterIndex].colorFilter ??
          const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
      child: CameraPreview(controller),
    );
  }

  Widget _buildCapturedImage(BuildContext context, CameraState state) {
    return ColorFiltered(
      colorFilter:
          PhotoFilter.filters[state.selectedFilterIndex].colorFilter ??
          const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
      child: Image.file(File(state.capturedImagePath!), fit: BoxFit.cover),
    );
  }

  Widget _buildFlashButton(BuildContext context, CameraState state) {
    IconData flashIcon;

    switch (state.flashMode) {
      case FlashMode.off:
        flashIcon = Icons.flash_off;
        break;
      case FlashMode.always:
        flashIcon = Icons.flash_on;
        break;
      case FlashMode.auto:
        flashIcon = Icons.flash_auto;
        break;
      default:
        flashIcon = Icons.flash_off;
    }

    return GestureDetector(
      onTap: () => context.read<CameraCubit>().toggleFlash(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(flashIcon, color: Colors.white, size: 24),
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

  Widget _buildFilterStrip(BuildContext context, CameraState state) {
    return SizedBox(
      height: 98,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: PhotoFilter.filters.length,
        itemBuilder: (context, index) {
          final filter = PhotoFilter.filters[index];
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
                child: ColorFiltered(
                  colorFilter:
                      filter.colorFilter ??
                      const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.multiply,
                      ),
                  child: Image.file(
                    File(state.capturedImagePath!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context, CameraState state) {
    if (state.capturedImagePath != null) {
      return _buildCapturedImageControls(context);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Gallery Button
        _buildGalleryButton(context),

        // Capture Button
        _buildCaptureButton(context, state),

        // Camera Reverse Button
        _buildCameraReverseButton(context),
      ],
    );
  }

  Widget _buildGalleryButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<CameraCubit>().pickFromGallery(),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.photo_library, color: Colors.white, size: 28),
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
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 24),
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

  Widget _buildHomeIndicator() {
    return Center(
      child: Container(
        width: 150,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
