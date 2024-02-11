import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Models/for_you_model.dart';
import '../Repositories/HomeRepo/home_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(GetPostInitialState()) {
    on<GetPostInitialEvent>(getPostInitialEvent);
    on<TabChangeEvent>(tabChangeEvent);
    on<PaginationEvent>(paginationEvent);
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
}
