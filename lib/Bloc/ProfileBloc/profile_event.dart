import '../../Models/bookmark_post_model.dart';

abstract class ProfileEvent {}

class GetPostInitialEvent extends ProfileEvent{}

class TabChangeEvent extends ProfileEvent{
  final int tabIndex;
  TabChangeEvent({required this.tabIndex});
}

class PostLikeEvent extends ProfileEvent{
  final BookmarkPostModel postData;
  final String previousEmojiType;
  final String emojisType;
  final List<BookmarkPostModel> listOfData;
  PostLikeEvent({
    required this.postData,
    required this.previousEmojiType,
    required this.emojisType,
    required this.listOfData,
  });
}

class PaginationEvent extends ProfileEvent{
  final int skip;
  final int limit;
  final List<BookmarkPostModel> allPrevPostData;
  final int tab;
  PaginationEvent({
    required this.limit,
    required this.skip,
    required this.allPrevPostData,
    required this.tab,
  });
}

class BookmarkPostEvent extends ProfileEvent{
  final BookmarkPostModel postData;
  final List<BookmarkPostModel> listOfData;
  final bool bookmark;
  BookmarkPostEvent({
    required this.postData,
    required this.listOfData,
    required this.bookmark,
  });
}




