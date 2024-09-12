import 'package:neuralcode/Models/for_you_model.dart';

abstract class HomeEvent {}

class GetHomePostInitialEvent extends HomeEvent{
  final String selectedTag;
  GetHomePostInitialEvent({required this.selectedTag});
}

class TabChangeEvent extends HomeEvent{
  final int tabIndex;
  final String selectedTag;
  TabChangeEvent({
    required this.tabIndex,
    required this.selectedTag,
  });
}

class HomePostLikeEvent extends HomeEvent{
  final ForYouModel postData;
  final String previousEmojiType;
  final String emojisType;
  final List<ForYouModel> listOfData;
  final String selectedTag;
  final List<ForYouModel>? listOfFutureData;
  HomePostLikeEvent({
    required this.postData,
    required this.previousEmojiType,
    required this.emojisType,
    required this.listOfData,
    required this.selectedTag,
    required this.listOfFutureData,
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

class HomeBookmarkPostEvent extends HomeEvent{
  final ForYouModel postData;
  final List<ForYouModel> listOfData;
  final bool bookmark;
  final String selectedTag;
  final List<ForYouModel>? listOfFutureData;
  HomeBookmarkPostEvent({
    required this.postData,
    required this.listOfData,
    required this.bookmark,
    required this.selectedTag,
    required this.listOfFutureData,
  });
}

class AdminActionEvent extends HomeEvent{
  final List<ForYouModel> listOfData;
  final ForYouModel postData;
  final String selectedTag;
  final List<ForYouModel>? listOfFutureData;
  AdminActionEvent({
    required this.postData,
    required this.listOfData,
    required this.selectedTag,
    required this.listOfFutureData,
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

class LanguageChange extends HomeEvent{
  final String selectedTag;
  final bool language;
  final List<ForYouModel> listOfPost;
  final List<ForYouModel>? listOfFutureData;
  LanguageChange({
    required this.language,
    required this.listOfPost,
    required this.selectedTag,
    required this.listOfFutureData,
  });
}






