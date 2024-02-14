import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Models/for_you_model.dart';
import '../../Repositories/HomeRepo/home_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(GetPostInitialState()) {
    on<GetPostInitialEvent>(getPostInitialEvent);
    on<TabChangeEvent>(tabChangeEvent);
    on<PaginationEvent>(paginationEvent);
    on<PostLikeEvent>(postLikeEvent);
  }
  FutureOr<void> getPostInitialEvent(
      HomeEvent event, Emitter<HomeState> emit) async {
    emit(GetPostLoadingState());
    try{
      var result = await HomeRepo.getAllPostDataOfForYou(
          email: "satishlangayan@gmail.com", skip: 0, limit: 5);
      if(result is List<ForYouModel>){
        emit(GetPostSuccessState(listOfPosts:result));
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
        var result = await HomeRepo.getAllPostDataOfForYou(
            email: "satishlangayan@gmail.com", skip: 0, limit: 5);
        if(result is List<ForYouModel>){
          emit(GetPostSuccessState(listOfPosts:result));
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
        var result = await HomeRepo.getAllPostDataOfTopPicks(
            email: "satishlangayan@gmail.com", skip: 0, limit: 5);
        if(result is List<ForYouModel>){
          emit(GetPostSuccessState(listOfPosts:result));
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
      try{
        var result = await HomeRepo.getAllPostDataOfForYou(
            email: "satishlangayan@gmail.com", skip: event.skip, limit: event.limit);
        if(result is List<ForYouModel>){
          List<ForYouModel> allPostData = event.allPrevPostData;
          List<ForYouModel> resultData =[];
          resultData.addAll(result);
          result.clear();
          result.addAll(allPostData);
          result.addAll(resultData);
          emit(GetPostSuccessState(listOfPosts:result));
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
      try{
        var result = await HomeRepo.reactionOnPost(
            email: "satishlangayan@gmail.com",
          emojisType: event.emojisType,
          previousEmojiType: event.previousEmojiType,
          postId: event.postData.id
        );
        if(result == "success"){
          var data = event.listOfData;
          int index=0;
          for(int i=0;i<data.length;i++){
            if(event.postData.id == data[i].id){
              break;
            }
            index+=1;
          }
          print("here");
          data.removeAt(index);
          data.insert(index, ForYouModel(
                  id: event.postData.id,
                  dateTime: event.postData.id,
                  imageUrl: event.postData.imageUrl,
                  myEmojis: [{
                    "type": "love"
                  }],
                  newsUrl: event.postData.newsUrl,
                  source: event.postData.source,
                  summary: event.postData.summary,
                  tags: event.postData.tags,
                  yt: event.postData.yt));
          emit(GetPostSuccessState(listOfPosts:data));
        }
        else{
          emit(GetPostFailureState(errorMessage: "Error"));
        }
      }
      catch(error){
        emit(GetPostFailureState(errorMessage: "Something went wrong"));
      }
  }
}
