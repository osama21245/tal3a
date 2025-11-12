import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

class CameraState extends Equatable {
  final bool isLoading;
  final bool isCameraInitialized;
  final bool isCapturing;
  final FlashMode flashMode;
  final int currentCameraIndex;
  final String? capturedImagePath;
  final int selectedFilterIndex;
  final bool showFilterBar;
  final bool showGalleryBar;
  final bool isLoadingGallery;
  final List<AssetEntity> galleryImages;
  final String? error;

  const CameraState({
    this.isLoading = false,
    this.isCameraInitialized = false,
    this.isCapturing = false,
    this.flashMode = FlashMode.off,
    this.currentCameraIndex = 0,
    this.capturedImagePath,
    this.selectedFilterIndex = 0,
    this.showFilterBar = false,
    this.showGalleryBar = true,
    this.isLoadingGallery = false,
    this.galleryImages = const [],
    this.error,
  });

  CameraState copyWith({
    bool? isLoading,
    bool? isCameraInitialized,
    bool? isCapturing,
    FlashMode? flashMode,
    int? currentCameraIndex,
    String? capturedImagePath,
    int? selectedFilterIndex,
    bool? showFilterBar,
    bool? showGalleryBar,
    bool? isLoadingGallery,
    List<AssetEntity>? galleryImages,
    String? error,
  }) {
    return CameraState(
      isLoading: isLoading ?? this.isLoading,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      isCapturing: isCapturing ?? this.isCapturing,
      flashMode: flashMode ?? this.flashMode,
      currentCameraIndex: currentCameraIndex ?? this.currentCameraIndex,
      capturedImagePath: capturedImagePath ?? this.capturedImagePath,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      showFilterBar: showFilterBar ?? this.showFilterBar,
      showGalleryBar: showGalleryBar ?? this.showGalleryBar,
      isLoadingGallery: isLoadingGallery ?? this.isLoadingGallery,
      galleryImages: galleryImages ?? this.galleryImages,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isCameraInitialized,
    isCapturing,
    flashMode,
    currentCameraIndex,
    capturedImagePath,
    selectedFilterIndex,
    showFilterBar,
    showGalleryBar,
    isLoadingGallery,
    galleryImages,
    error,
  ];
}
