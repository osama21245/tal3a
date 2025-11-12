🎬 Tal3a Vibes / Reels in Community Feature Implementation
🚀 Overview

The Tal3a Vibes feature (Community Reels) has been implemented using Clean Architecture.
This feature allows users to watch short videos, interact with them via likes, follow creators, add/delete comments, and upload their own videos.

Videos are played using VideoPlayerController

Users can interact with videos (Like / Follow / Comment)

Each video has a progress bar

Smooth loading experience using Shimmer

📁 Files Created / Modified
New Files Created

lib/features/videos/data/models/video_model.dart

lib/features/videos/data/models/video_upload_request_model.dart

lib/features/videos/data/models/video_upload_response_model.dart

lib/features/videos/data/models/comment_model.dart

lib/features/videos/data/data_source/video_data_source.dart

lib/features/videos/data/repositories/video_repository_impl.dart

lib/features/videos/presentation/controllers/video_cubit.dart

lib/features/videos/presentation/controllers/video_state.dart

lib/features/videos/presentation/widgets/video_item.dart

lib/features/videos/presentation/widgets/like_button.dart

lib/features/videos/presentation/screens/video_show.dart

Modified Files

lib/core/network/api_client.dart – Added support for Multipart upload (video uploads)

lib/core/constants/api_constants.dart – Added video-related API endpoints

🔧 API Integration & Endpoints

Get For You Videos

GET /api/v1/tal3aVibesRoute/videos/foryou


Returns recommended videos for the user (Reels feed)

Response: List of videos with user info, description, and links

Like Video

POST /api/v1/tal3aVibesRoute/like/{videoId}


Toggle like/unlike for a video

Response: Updated like count

Upload Video

POST /api/v1/tal3aVibesRoute/uploadVideo


Request (Multipart):

video: video file

description: video description

hashtags: list of hashtags

Response:

{
  "status": true,
  "message": "Video uploaded successfully",
  "data": { "videoId": "id_here", "videoUrl": "url_here" }
}


Get My Posts

GET /api/v1/tal3aVibesRoute/myPosts?page=1&limit=10&status=active


Returns the current user's videos

Response: List of user videos

Get Comments

GET /api/v1/tal3aVibesRoute/comments/{videoId}?page=1&limit=20


Response: List of comments on a video

Post Comment

POST /api/v1/tal3aVibesRoute/comment/{videoId}


Body:

{ "text": "Comment text" }


Response: The newly added comment

Delete Comment

DELETE /api/v1/tal3aVibesRoute/deleteComment/{commentId}


Response: Success or failure of deletion

🎨 UI Integration

VideoShow Screen

Displays videos in a vertical PageView

Plays the current video and pauses the previous one automatically

Shows VideoProgressIndicator below each video

Smooth loading experience using Shimmer

ReelItem Widget

Displays video using VideoPlayerController

Shows user avatar + follow button if not following

Like button and interaction options

Video description overlay

Supports comments with count and interaction

User Interactions

Likes: Updates count instantly

Follow: Displays Follow button for unfollowed users

Comments: Can view, add, or delete comments directly

Loading & Error Handling

Shimmer placeholder during video loading

CircularProgressIndicator for individual video loading

Displays error message if video fetch or interactions fail

🔄 State Management

Cubit: VideoCubit

State: VideoState

Key State Properties

isLoading → Indicates video loading

isError → Indicates error while fetching data

videos → List of videos

error → Error message text

All interactions (like, follow, comment) are handled through the Cubit to maintain state consistency.

🛠️ Technical Implementation

Clean Architecture

Models: VideoModel, CommentModel

DataSource: VideoDataSourceImpl for API calls

Repository: VideoRepositoryImpl for business logic

Cubit: VideoCubit for state management

UI: VideoShow, ReelItem, LikeButton

File Handling

Videos are played via VideoPlayerController with proper disposal

Error Handling

Network or API errors are displayed in UI

Unloaded videos show Shimmer placeholder

📱 User Experience

User opens the page → videos start loading

Vertical scrolling of videos

Users can like, follow, or comment on videos

Previous video pauses automatically on scroll

Video progress bar displayed below each video

Smooth loading experience using Shimmer

🎯 Next Steps

Support video upload directly from the app

Multi-video upload at once

Add video effects (Filters / Text overlay)

Support video edit & delete

Improve performance for long videos

🔗 Dependencies

flutter_bloc → state management

video_player → video playback

shimmer → loading placeholders

http → API communication

fpdart → error handling (Either<Failure, T>)