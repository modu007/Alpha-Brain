import 'package:neuralcode/Models/notification_post_model.dart';

abstract class NotificationPostState {}

abstract class NotificationPostActionState extends NotificationPostState{}

class NotificationPostInitial extends NotificationPostState {}

class NotificationPostLoading extends NotificationPostState {}

class NotificationPostSuccess extends NotificationPostState {
  final NotificationPostModel listOfPosts;
  final bool language;
  NotificationPostSuccess({
    required this.listOfPosts,
    required this.language
  });
}

class NotificationPostError extends NotificationPostState {
  final String errorMessage;
  NotificationPostError({required this.errorMessage});
}
