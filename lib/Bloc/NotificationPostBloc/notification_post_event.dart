abstract class NotificationPostEvent {}

class GetPostInitialEvent extends NotificationPostEvent{
  final String postId;
  GetPostInitialEvent({required this.postId});
}
