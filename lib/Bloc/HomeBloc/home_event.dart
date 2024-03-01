import 'package:neuralcode/Models/for_you_model.dart';

abstract class HomeEvent {}

class GetPostInitialEvent extends HomeEvent{}

class TabChangeEvent extends HomeEvent{
  final int tabIndex;
  TabChangeEvent({required this.tabIndex});
}

class PostLikeEvent extends HomeEvent{
  final ForYouModel postData;
  final String previousEmojiType;
  final String emojisType;
  final List<ForYouModel> listOfData;
  PostLikeEvent({
    required this.postData,
    required this.previousEmojiType,
    required this.emojisType,
    required this.listOfData,
  });
}

class PaginationEvent extends HomeEvent{
  final int skip;
  final int limit;
  final List<ForYouModel> allPrevPostData;
  final int tab;
  PaginationEvent({
    required this.limit,
    required this.skip,
    required this.allPrevPostData,
    required this.tab,
  });
}

class BookmarkPostEvent extends HomeEvent{
  final ForYouModel postData;
  final List<ForYouModel> listOfData;
  final bool bookmark;
  BookmarkPostEvent({
    required this.postData,
    required this.listOfData,
    required this.bookmark,
  });
}

class AdminActionEvent extends HomeEvent{
  final List<ForYouModel> listOfData;
  final ForYouModel postData;
  AdminActionEvent({
    required this.postData,
    required this.listOfData,
  });
}




