import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/core/services/permission_service.dart';
import 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(const CameraState());

  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  final ImagePicker _imagePicker = ImagePicker();
  List<AssetEntity> _galleryImages = [];

  /// Load gallery images
  Future<void> loadGalleryImages() async {
    try {
      emit(state.copyWith(isLoadingGallery: true));

      // Request PhotoManager permission directly
      final PermissionState permission =
          await PhotoManager.requestPermissionExtend();

      print('PhotoManager permission state: ${permission.name}');
      print('PhotoManager isAuth: ${permission.isAuth}');

      // Try to continue even if permission is not fully authorized
      // Sometimes PhotoManager is overly strict
      if (permission == PermissionState.denied ||
          permission == PermissionState.restricted) {
        emit(
          state.copyWith(
            isLoadingGallery: false,
            error: 'story.gallery_permission_denied'.tr(),
          ),
        );
        return;
      }

      // Get recent images
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );

      print('Found ${albums.length} albums');

      if (albums.isNotEmpty) {
        final AssetPathEntity recentAlbum = albums.first;
        final List<AssetEntity> media = await recentAlbum.getAssetListPaged(
          page: 0,
          size: 50, // Load last 50 images
        );

        _galleryImages = media;
        emit(
          state.copyWith(
            isLoadingGallery: false,
            galleryImages: _galleryImages,
          ),
        );
      } else {
        emit(state.copyWith(isLoadingGallery: false, galleryImages: []));
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingGallery: false,
          error: 'story.failed_to_load_gallery'.tr(),
        ),
      );
    }
  }

  /// Initialize camera
  Future<void> initializeCamera() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      // Check camera permission first
      final hasCameraPermission =
          await PermissionService.isCameraPermissionGranted();
      if (!hasCameraPermission) {
        final granted = await PermissionService.requestCameraPermission();
        if (!granted) {
          emit(
            state.copyWith(
              isLoading: false,
              error: 'story.permission_camera'.tr(),
            ),
          );
          return;
        }
      }

      // Get available cameras
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        emit(state.copyWith(isLoading: false, error: 'No cameras available'));
        return;
      }

      // Initialize with back camera by default
      await _initializeCameraController(_cameras.first);

      emit(
        state.copyWith(
          isLoading: false,
          isCameraInitialized: true,
          currentCameraIndex: 0,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to initialize camera: $e',
        ),
      );
    }
  }

  Future<void> _initializeCameraController(CameraDescription camera) async {
    // Dispose previous controller if exists
    await _cameraController?.dispose();

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _cameraController!.initialize();

    // Set flash mode to off by default
    await _cameraController!.setFlashMode(FlashMode.off);
  }

  /// Get camera controller for UI
  CameraController? get cameraController => _cameraController;

  /// Toggle flash mode
  Future<void> toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final currentFlashMode = state.flashMode;
      FlashMode newFlashMode;

      switch (currentFlashMode) {
        case FlashMode.off:
          newFlashMode = FlashMode.always;
          break;
        case FlashMode.always:
          newFlashMode = FlashMode.auto;
          break;
        case FlashMode.auto:
          newFlashMode = FlashMode.off;
          break;
        default:
          newFlashMode = FlashMode.off;
      }

      await _cameraController!.setFlashMode(newFlashMode);
      emit(state.copyWith(flashMode: newFlashMode));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to toggle flash: $e'));
    }
  }

  /// Switch between front and back camera
  Future<void> switchCamera() async {
    if (_cameras.length < 2) {
      emit(state.copyWith(error: 'No other camera available'));
      return;
    }

    try {
      emit(state.copyWith(isLoading: true));

      final newIndex = (state.currentCameraIndex + 1) % _cameras.length;
      await _initializeCameraController(_cameras[newIndex]);

      emit(
        state.copyWith(
          isLoading: false,
          currentCameraIndex: newIndex,
          isCameraInitialized: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Failed to switch camera: $e'),
      );
    }
  }

  /// Capture photo from camera
  Future<void> capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      emit(state.copyWith(error: 'Camera not initialized'));
      return;
    }

    try {
      emit(state.copyWith(isCapturing: true));

      final XFile photo = await _cameraController!.takePicture();

      emit(
        state.copyWith(
          isCapturing: false,
          capturedImagePath: photo.path,
          showGalleryBar: false,
          showFilterBar: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isCapturing: false,
          error: 'Failed to capture photo: $e',
        ),
      );
    }
  }

  /// Pick image from gallery
  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        emit(state.copyWith(capturedImagePath: image.path));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to pick image: $e'));
    }
  }

  /// Toggle filter bar visibility
  void toggleFilterBar() {
    final newShowFilterBar = !state.showFilterBar;
    emit(
      state.copyWith(
        showFilterBar: newShowFilterBar,
        showGalleryBar:
            !newShowFilterBar, // Show gallery when hiding filters, hide when showing filters
      ),
    );
  }

  /// Toggle gallery bar visibility
  void toggleGalleryBar() {
    final newShowGalleryBar = !state.showGalleryBar;
    emit(
      state.copyWith(
        showGalleryBar: newShowGalleryBar,
        showFilterBar:
            !newShowGalleryBar, // Show filters when hiding gallery, hide when showing gallery
      ),
    );
  }

  /// Select a filter
  void selectFilter(int filterIndex) {
    emit(state.copyWith(selectedFilterIndex: filterIndex));
  }

  /// Select image from gallery
  Future<void> selectGalleryImage(AssetEntity asset) async {
    try {
      final File? file = await asset.file;
      if (file != null) {
        emit(
          state.copyWith(
            capturedImagePath: file.path,
            showGalleryBar: false,
            showFilterBar: false,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to select image: $e'));
    }
  }

  /// Clear captured image
  void clearCapturedImage() {
    emit(
      state.copyWith(
        capturedImagePath: null,
        showGalleryBar: true, // Show gallery again when going back to camera
        showFilterBar: false,
      ),
    );
  }

  /// Clear error
  void clearError() {
    emit(state.copyWith(error: null));
  }

  @override
  Future<void> close() async {
    await _cameraController?.dispose();
    return super.close();
  }
}
