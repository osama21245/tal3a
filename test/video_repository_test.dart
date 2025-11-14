import 'package:flutter_test/flutter_test.dart';
import 'package:tal3a/core/network/api_client.dart';
import 'package:tal3a/features/videos/data/data_source/video_data_source.dart';
import 'package:tal3a/features/videos/data/repositories/video_repository_impl.dart';
import 'package:tal3a/features/videos/data/model/comment_model.dart';

void main() {
   TestWidgetsFlutterBinding.ensureInitialized();
  late VideoRepositoryImpl repository;
  late VideoDataSource dataSource;

  setUp(() {
    dataSource = VideoDataSourceImpl(apiClient: ApiClient());
    repository = VideoRepositoryImpl(dataSource: dataSource, userId:'' );
  });

  test('Post comment via repository', () async {
    final videoId = '691506f2519810ce298fb951';
    final text = 'Hello from test file';

    final result = await repository.postComment(videoId: videoId, text: text);

    result.fold(
      (failure) => fail('Failed to post comment: ${failure.message}'),
      (CommentModel comment) {
        expect(comment.text, text);
        expect(comment.id.isNotEmpty, true);
        expect(comment.videoId, videoId);
      },
    );
  });
}
