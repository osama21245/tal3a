import 'package:tal3a/features/videos/data/model/video_model.dart';


class VideoState {
  final bool isLoading;
  final bool isError;
  final String? error;
  final List<VideoModel> videos;
  

  VideoState({
    this.isLoading = false,
    this.isError = false,
    this.error,
    this.videos = const [],
  
  });

  VideoState copyWith({
    bool? isLoading,
    bool? isError,
    String? error,
    List<VideoModel>? videos,
  
  }) {
    return VideoState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      error: error ?? this.error,
      videos: videos ?? this.videos,
    
    );
  }
}
