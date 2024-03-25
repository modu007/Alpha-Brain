import 'package:neuralcode/Models/for_you_model.dart';

abstract class HomeEvent {}

class GetPostInitialEvent extends HomeEvent{
  final String selectedTag;
  GetPostInitialEvent({required this.selectedTag});
}

class TabChangeEvent extends HomeEvent{
  final int tabIndex;
  final String selectedTag;
  TabChangeEvent({
    required this.tabIndex,
    required this.selectedTag,
  });
}

class PostLikeEvent extends HomeEvent{
  final ForYouModel postData;
  final String previousEmojiType;
  final String emojisType;
  final List<ForYouModel> listOfData;
  final String selectedTag;
  PostLikeEvent({
    required this.postData,
    required this.previousEmojiType,
    required this.emojisType,
    required this.listOfData,
    required this.selectedTag,
  });
}

class PaginationEvent extends HomeEvent{
  final int skip;
  final int limit;
  final List<ForYouModel> allPrevPostData;
  final int tab;
  final String selectedTag;
  PaginationEvent({
    required this.limit,
    required this.skip,
    required this.allPrevPostData,
    required this.tab,
    required this.selectedTag,
  });
}

class BookmarkPostEvent extends HomeEvent{
  final ForYouModel postData;
  final List<ForYouModel> listOfData;
  final bool bookmark;
  final String selectedTag;
  BookmarkPostEvent({
    required this.postData,
    required this.listOfData,
    required this.bookmark,
    required this.selectedTag,
  });
}

class AdminActionEvent extends HomeEvent{
  final List<ForYouModel> listOfData;
  final ForYouModel postData;
  final String selectedTag;
  AdminActionEvent({
    required this.postData,
    required this.listOfData,
    required this.selectedTag,
  });
}

class TagSelectedEvent extends HomeEvent{
  final String selectedTag;
  final int tabIndex;
  TagSelectedEvent({
    required this.selectedTag,
    required this.tabIndex,
  });
}






