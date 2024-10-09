import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Models/notification_post_model.dart';
import 'package:neuralcode/SharedPrefernce/shared_pref.dart';
import '../../Repositories/HomeRepo/home_repo.dart';
import '../../Repositories/NotificationPostRepo/notification_post_repo.dart';
import 'notification_post_event.dart';
import 'notification_post_state.dart';

class NotificationPostBloc extends Bloc<NotificationPostEvent, NotificationPostState> {
  NotificationPostBloc() : super(NotificationPostInitial()) {
    on<GetPostInitialEvent>(getPostInitialEvent);
    on<PostLikeEvent>(postLikeEvent);
    on<BookmarkPostEvent>(bookmarkPostEvent);
  }

  FutureOr<void> getPostInitialEvent(
      GetPostInitialEvent event, Emitter<NotificationPostState> emit) async
  {
    emit(NotificationPostLoading());
    try{
      var result = await NotificationRepo.getPostById(
          postId: event.postId);
      await NotificationRepo.userNotifiedRepo(
          postId: event.postId);
      bool language =await SharedData.getToken("language");
      if(result is NotificationPostModel){
        emit(NotificationPostSuccess(
            listOfPosts:result,
          language: language
        ));
      }else{
        emit(NotificationPostError(errorMessage: "Error"));
      }
    }
    catch(error){
      emit(NotificationPostError(errorMessage: "Something went wrong"));
    }
  }

  FutureOr<void> postLikeEvent(
      PostLikeEvent event, Emitter<NotificationPostState> emit) async
  {
    NotificationPostModel result;
   if(event.postData.myEmojis!.isEmpty){
      result = NotificationPostModel(
         id: event.postData.id,
         dateTime: event.postData.dateTime,
         imageUrl:  event.postData.imageUrl,
         myBookmark:  event.postData.myBookmark,
         myEmojis: [{
         "emoji": "love"
         }],
         newsUrl:  event.postData.newsUrl,
         source:  event.postData.source,
         summary:  event.postData.summary,
         tags:  event.postData.tags,
         yt:  event.postData.yt,
        summaryHi: event.postData.summaryHi,love: event.postData.love, shortUrl: event.postData.shortUrl,
      );
   }else{
     result = NotificationPostModel(
         id: event.postData.id,
         dateTime: event.postData.dateTime,
         imageUrl:  event.postData.imageUrl,
         myBookmark:  event.postData.myBookmark,
         myEmojis: [],
         newsUrl:  event.postData.newsUrl,
         source:  event.postData.source,
         summary:  event.postData.summary,
         tags:  event.postData.tags,
         yt:  event.postData.yt,
       summaryHi: event.postData.summaryHi,love: event.postData.love,
       shortUrl: event.postData.shortUrl
     );
   }
    bool language =await SharedData.getToken("language");
   emit(NotificationPostSuccess(listOfPosts: result,language: language));
    try{
      var result = await HomeRepo.reactionOnPost(
          emojisType: event.emojisType,
          previousEmojiType: event.previousEmojiType,
          postId: event.postData.id
      );
      if(result == "success"){
      }
      else{
        emit(NotificationPostError(errorMessage: "Error"));
      }
    }
    catch(error){
      emit(NotificationPostError(errorMessage: "Something went wrong"));
    }
  }

FutureOr<void> bookmarkPostEvent(
    BookmarkPostEvent event, Emitter<NotificationPostState> emit) async
  {
    NotificationPostModel result;
    if(event.bookmark){
      result = NotificationPostModel(
          id: event.postData.id,
          dateTime: event.postData.dateTime,
          imageUrl:  event.postData.imageUrl,
          myBookmark: [
            {"bookmarked": true}
          ],
          myEmojis: event.postData.myEmojis,
          newsUrl:  event.postData.newsUrl,
          source:  event.postData.source,
          summary:  event.postData.summary,
          tags:  event.postData.tags,
          yt:  event.postData.yt,
        summaryHi: event.postData.summaryHi,
        love: event.postData.love,
        shortUrl: event.postData.shortUrl,
      );
    }else{
      result = NotificationPostModel(
          id: event.postData.id,
          dateTime: event.postData.dateTime,
          imageUrl:  event.postData.imageUrl,
          myBookmark: [],
          myEmojis: event.postData.myEmojis,
          newsUrl:  event.postData.newsUrl,
          source:  event.postData.source,
          summary:  event.postData.summary,
          tags:  event.postData.tags,
          yt:  event.postData.yt, summaryHi: event.postData.summaryHi,love: event.postData.love,
        shortUrl: event.postData.shortUrl,);
    }
    bool language =await SharedData.getToken("language");
    emit(NotificationPostSuccess(listOfPosts: result,language: language));
    try{
      var result = await HomeRepo.bookmarkPost(
          postId: event.postData.id,
          bookmark: event.bookmark
      );
      if(result == "success"){
      }
      else if(result =="removed"){
      }
      else{
        emit(NotificationPostError(errorMessage: "Error"));
      }
    }
    catch(error){
      emit(NotificationPostError(errorMessage: "Something went wrong"));
    }
  }
}
