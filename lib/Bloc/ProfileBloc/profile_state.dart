import 'package:neuralcode/Models/bookmark_post_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

abstract class ProfileActionState extends ProfileState {}

class GetPostInitialState extends ProfileState {}

class GetPostLoadingState extends ProfileState {}

class GetPostFailureState extends ProfileState {
  final String errorMessage;

  GetPostFailureState({required this.errorMessage});
}

class GetPostSuccessState extends ProfileState{
  final List<BookmarkPostModel> listOfPosts;
  final List<BookmarkPostModel>? listOfFutureData;
  GetPostSuccessState({
    required this.listOfPosts,
    required this.listOfFutureData});
}