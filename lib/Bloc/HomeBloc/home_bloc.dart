import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Models/for_you_model.dart';
import 'package:neuralcode/SharedPrefernce/shared_pref.dart';
import '../../Repositories/HomeRepo/home_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(GetPostInitialState()) {
    on<GetPostInitialEvent>(getPostInitialEvent);
    on<TabChangeEvent>(tabChangeEvent);
    on<PaginationEvent>(paginationEvent);
    on<PostLikeEvent>(postLikeEvent);
    on<BookmarkPostEvent>(bookmarkPostEvent);
    on<AdminActionEvent>(adminActionEvent);
  }
  FutureOr<void> getPostInitialEvent(
      HomeEvent event, Emitter<HomeState> emit) async {
    emit(GetPostLoadingState());
    try{
      var result = await HomeRepo.getAllPostDataOfForYou(skip: 0, limit: 5);
      if(result is List<ForYouModel>){
        String email =await SharedData.getEmail("email");
        bool isAdmin =false;
        if(email == "satishlangayan@gmail.com"){
          isAdmin=true;
        }
        emit(GetPostSuccessState(listOfPosts:result,isAdmin: isAdmin));
      }else{
        emit(GetPostFailureState(errorMessage: "Error"));
      }
    }
    catch(error){
     emit(GetPostFailureState(errorMessage: "Something went wrong"));
    }
  }

  FutureOr<void> tabChangeEvent(
      TabChangeEvent event, Emitter<HomeState> emit) async {
    emit(GetPostLoadingState());
    if(event.tabIndex ==0){
      try{
        var result = await HomeRepo.getAllPostDataOfForYou(skip: 0, limit: 5);
        if(result is List<ForYouModel>){
          String email =await SharedData.getEmail("email");
          bool isAdmin =false;
          if(email == "satishlangayan@gmail.com"){
            isAdmin=true;
          }
          emit(GetPostSuccessState(listOfPosts:result,isAdmin: isAdmin));
        }else{
          emit(GetPostFailureState(errorMessage: "Error"));
        }
      }
      catch(error){
        emit(GetPostFailureState(errorMessage: "Something went wrong"));
      }
    }
    else{
      try{
        var result = await HomeRepo.getAllPostDataOfTopPicks(skip: 0, limit: 5);
        if(result is List<ForYouModel>){
          String email =await SharedData.getEmail("email");
          bool isAdmin =false;
          if(email == "satishlangayan@gmail.com"){
            isAdmin=true;
          }
          emit(GetPostSuccessState(listOfPosts:result,isAdmin: isAdmin));
        }else{
          emit(GetPostFailureState(errorMessage: "Error"));
        }
      }
      catch(error){
        emit(GetPostFailureState(errorMessage: "Something went wrong"));
      }
      }
    }

  FutureOr<void> paginationEvent(
      PaginationEvent event, Emitter<HomeState> emit) async {
    var result;
      try{
        if(event.tab==0){
           result = await HomeRepo.getAllPostDataOfForYou(
              skip: event.skip, limit: event.limit);
        }
        else{
           result = await HomeRepo.getAllPostDataOfTopPicks(
              skip: event.skip, limit: event.limit);
        }
        if(result is List<ForYouModel>){
          List<ForYouModel> allPostData = event.allPrevPostData;
          List<ForYouModel> resultData =[];
          resultData.addAll(result);
          result.clear();
          result.addAll(allPostData);
          result.addAll(resultData);
          String email =await SharedData.getEmail("email");
          bool isAdmin =false;
          if(email == "satishlangayan@gmail.com"){
            isAdmin=true;
          }
          emit(GetPostSuccessState(listOfPosts:result,isAdmin: isAdmin));
        }else{
          emit(GetPostFailureState(errorMessage: "Error"));
        }
      }
      catch(error){
        emit(GetPostFailureState(errorMessage: "Something went wrong"));
      }
  }

  FutureOr<void> postLikeEvent(
      PostLikeEvent event, Emitter<HomeState> emit) async {
    int? loveCount = event.postData.love;
    var data = event.listOfData;
    int index=0;
    for(int i=0;i<data.length;i++){
      if(event.postData.id == data[i].id){
        break;
      }
      index+=1;
    }
    data.removeAt(index);
    if(event.postData.myEmojis.isEmpty){
      if(loveCount == null){
        loveCount =1;
      }else{
        loveCount = loveCount+1;
      }
      data.insert(index, ForYouModel(
        id: event.postData.id,
        dateTime: event.postData.dateTime,
        imageUrl: event.postData.imageUrl,
        myEmojis: [{
          "emoji": "love"
        }],
        newsUrl: event.postData.newsUrl,
        source: event.postData.source,
        summary: event.postData.summary,
        tags: event.postData.tags,
        yt: event.postData.yt,
        love:loveCount,
        myBookmark: event.postData.myBookmark,
      ));
    }
    else{
      if(loveCount==1){
        loveCount=null;
      }else{
        loveCount = loveCount!-1;
      }
      data.insert(index, ForYouModel(
        id: event.postData.id,
        dateTime: event.postData.dateTime,
        imageUrl: event.postData.imageUrl,
        myEmojis: [],
        newsUrl: event.postData.newsUrl,
        source: event.postData.source,
        summary: event.postData.summary,
        tags: event.postData.tags,
        yt: event.postData.yt,
        love: loveCount,
        myBookmark: event.postData.myBookmark,
      ));
    }
    String email =await SharedData.getEmail("email");
    bool isAdmin =false;
    if(email == "satishlangayan@gmail.com"){
      isAdmin=true;
    }
    emit(GetPostSuccessState(listOfPosts:data,isAdmin: isAdmin));
    try{
        var result = await HomeRepo.reactionOnPost(
          emojisType: event.emojisType,
          previousEmojiType: event.previousEmojiType,
          postId: event.postData.id
        );
        if(result == "success"){
        }
        else{
          emit(GetPostFailureState(errorMessage: "Error"));
        }
      }
      catch(error){
        emit(GetPostFailureState(errorMessage: "Something went wrong"));
      }
  }

  FutureOr<void> bookmarkPostEvent(
      BookmarkPostEvent event, Emitter<HomeState> emit) async {
    var data = event.listOfData;
    int index=0;
    for(int i=0;i<data.length;i++){
      if(event.postData.id == data[i].id){
        break;
      }
      index+=1;
    }
    data.removeAt(index);
    if(event.bookmark){
      data.insert(index, ForYouModel(
          id: event.postData.id,
          dateTime: event.postData.dateTime,
          imageUrl: event.postData.imageUrl,
          myEmojis: event.postData.myEmojis,
          newsUrl: event.postData.newsUrl,
          source: event.postData.source,
          summary: event.postData.summary,
          tags: event.postData.tags,
          yt: event.postData.yt,
          love: event.postData.love,
          myBookmark: [
            {
              "bookmarked": true
            }
          ]
      ));
    }else{
      data.insert(index, ForYouModel(
          id: event.postData.id,
          dateTime: event.postData.dateTime,
          imageUrl: event.postData.imageUrl,
          myEmojis: event.postData.myEmojis,
          newsUrl: event.postData.newsUrl,
          source: event.postData.source,
          summary: event.postData.summary,
          tags: event.postData.tags,
          yt: event.postData.yt,
          love: event.postData.love,
          myBookmark: []
      ));
    }
    String email =await SharedData.getEmail("email");
    bool isAdmin =false;
    if(email == "satishlangayan@gmail.com"){
      isAdmin=true;
    }
    emit(GetPostSuccessState(listOfPosts:data,isAdmin: isAdmin));
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
        emit(GetPostFailureState(errorMessage: "Error"));
      }
    }
    catch(error){
      emit(GetPostFailureState(errorMessage: "Something went wrong"));
    }
  }

  FutureOr<void> adminActionEvent(
      AdminActionEvent event, Emitter<HomeState> emit) async {
    int index=0;
   for(int i=0; i<event.listOfData.length;i++){
     if(event.listOfData[i].id == event.postData.id){
       break;
     }
     index++;
   }
   final List<ForYouModel> data = [];
   data.addAll(event.listOfData);
   data.removeAt(index);
    String email =await SharedData.getEmail("email");
    bool isAdmin =false;
    if(email == "satishlangayan@gmail.com"){
      isAdmin=true;
    }
   emit(GetPostSuccessState(listOfPosts: data, isAdmin: isAdmin));
    try{
      await HomeRepo.adminAction(
          postId: event.postData.id,
      );
    }
    catch(error){
      emit(GetPostFailureState(errorMessage: "Something went wrong"));
    }
  }
}
