import 'package:neuralcode/Models/for_you_model.dart';

abstract class HomeEvent {}

class GetPostInitialEvent extends HomeEvent{}

class TabChangeEvent extends HomeEvent{
  final int tabIndex;
  TabChangeEvent({required this.tabIndex});
}

class PostLikeEvent extends HomeEvent{
  final ForYouModel postData;
  PostLikeEvent({required this.postData});
}

class PaginationEvent extends HomeEvent{
  final int skip;
  final int limit;
  final List<ForYouModel> allPrevPostData;
  PaginationEvent({
    required this.limit,
    required this.skip,
    required this.allPrevPostData,
  });
}
