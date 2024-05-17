import '../../Models/bookmark_post_model.dart';
import '../../Models/for_you_model.dart';

abstract class HomeState {}

abstract class HomeActionState extends HomeState {}

class GetPostInitialState extends HomeState {}

class GetPostLoadingState extends HomeState {}

class GetPostFailureState extends HomeState {
  final String errorMessage;

  GetPostFailureState({required this.errorMessage});
}

class GetPostSuccessState extends HomeState{
  final List<ForYouModel> listOfPosts;
  final bool isAdmin;
  final String selectedTag;
  final bool languageChange;
  final List<ForYouModel>? listOfFutureData;
  GetPostSuccessState({
    required this.listOfFutureData,
    required this.listOfPosts,
    required this.isAdmin,
    required this.selectedTag,
    required this.languageChange,
  });
}

