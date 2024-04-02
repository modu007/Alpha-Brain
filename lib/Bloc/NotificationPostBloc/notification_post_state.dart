import '../../Models/for_you_model.dart';

abstract class NotificationPostState {}


abstract class NotificationPostActionState extends NotificationPostState{

}

class NotificationPostInitial extends NotificationPostState {}

class NotificationPostLoading extends NotificationPostState {}

class NotificationPostSuccess extends NotificationPostState {
  final ForYouModel listOfPosts;
  final bool isAdmin;
  NotificationPostSuccess({
    required this.listOfPosts,
    required this.isAdmin,
  });
}

class NotificationPostError extends NotificationPostState {
  final String errorMessage;
  NotificationPostError({required this.errorMessage});
}
