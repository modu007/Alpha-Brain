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
  GetPostSuccessState({
    required this.listOfPosts,
    required this.isAdmin,
  });
}

