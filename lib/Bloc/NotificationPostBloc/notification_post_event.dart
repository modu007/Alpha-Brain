import 'package:neuralcode/Models/notification_post_model.dart';

abstract class NotificationPostEvent {}

class GetPostInitialEvent extends NotificationPostEvent{
  final String postId;
  GetPostInitialEvent({required this.postId});
}

class PostLikeEvent extends NotificationPostEvent{
  final NotificationPostModel postData;
  final String previousEmojiType;
  final String emojisType;
  PostLikeEvent({
    required this.postData,
    required this.previousEmojiType,
    required this.emojisType,
  });
}

class BookmarkPostEvent extends NotificationPostEvent{
  final NotificationPostModel postData;
  final bool bookmark;
  BookmarkPostEvent({
    required this.postData,
    required this.bookmark,
  });
}