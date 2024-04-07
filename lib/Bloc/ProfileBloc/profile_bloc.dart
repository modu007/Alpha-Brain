import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/ProfileBloc/profile_event.dart';
import 'package:neuralcode/Bloc/ProfileBloc/profile_state.dart';
import 'package:neuralcode/Models/bookmark_post_model.dart';
import '../../Repositories/ProfileRepo/profile_repo.dart';
import '../../SharedPrefernce/shared_pref.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<GetPostInitialEvent>(getPostInitialEvent);
    on<TabChangeEvent>(tabChangeEvent);
    on<PaginationEvent>(paginationEvent);
    on<LanguageChangeBloc>(languageChange);
  }
  FutureOr<void> getPostInitialEvent(
      ProfileEvent event, Emitter<ProfileState> emit) async {
    emit(GetPostLoadingState());
    try{
      var result = await ProfileRepo.getAllLikesData(skip: 0, limit: 5);
      bool language = await SharedData.getToken("language");
      if(result is List<BookmarkPostModel>){
        if(result.length==1){
          emit(GetPostSuccessState(
              listOfPosts:result,listOfFutureData: [],
            language: language
          ));
        }else{
          emit(GetPostSuccessState(
              listOfPosts:result,listOfFutureData: null,
            language: language
          ));
        }
      }else{
        emit(GetPostFailureState(errorMessage: "Error"));
      }
    }
    catch(error){
      emit(GetPostFailureState(errorMessage: "Something went wrong"));
    }
  }

  FutureOr<void> tabChangeEvent(
      TabChangeEvent event, Emitter<ProfileState> emit) async {
    emit(GetPostLoadingState());
    if(event.tabIndex ==0){
      try{
        var result = await ProfileRepo.getAllLikesData(skip: 0, limit: 5);
        bool language = await SharedData.getToken("language");

        if(result is List<BookmarkPostModel>){
          if(result.length==1){
            emit(GetPostSuccessState(
                listOfPosts: result, listOfFutureData: [], language: language));
          }else{
            emit(GetPostSuccessState(
                listOfPosts:result,
                listOfFutureData: null,
              language: language
            ));
          }
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
        var result = await ProfileRepo.getAllBookmarksData(skip: 0, limit: 5);
        bool language = await SharedData.getToken("language");
        if(result is List<BookmarkPostModel>){
          if(result.length==1){
            if(result.length==1){
              emit(GetPostSuccessState(
                  listOfPosts:result,
                  listOfFutureData: [],
                language: language
              ));
            }else{
              emit(GetPostSuccessState(
                  listOfPosts: result, listOfFutureData: null,language:language
              ));
            }
          }else{
            emit(GetPostSuccessState(
                listOfPosts:result,
                listOfFutureData: null,
              language: language
            ));
          }
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
      PaginationEvent event, Emitter<ProfileState> emit) async {
    // ignore: prefer_typing_uninitialized_variables
    var result;
    try{
      if(event.tab==0){
        result = await ProfileRepo.getAllLikesData(
            skip: event.skip, limit: event.limit);
      }
      else{
        result = await ProfileRepo.getAllBookmarksData(
            skip: event.skip, limit: event.limit);
      }
      if(result is List<BookmarkPostModel>){
        List<BookmarkPostModel> allPostData = event.allPrevPostData;
        List<BookmarkPostModel>? listOfFutureData=[];
        bool language = await SharedData.getToken("language");
        if(result.isNotEmpty) {
          listOfFutureData = null;
        }
        List<BookmarkPostModel> resultData =[];
        resultData.addAll(result);
        result.clear();
        result.addAll(allPostData);
        result.addAll(resultData);
        emit(GetPostSuccessState(
            listOfPosts:result,
            listOfFutureData: listOfFutureData,
          language: language
        ));
      }else{
        emit(GetPostFailureState(errorMessage: "Error"));
      }
    }
    catch(error){
      emit(GetPostFailureState(errorMessage: "Something went wrong"));
    }
  }

  FutureOr<void> languageChange(
      LanguageChangeBloc event, Emitter<ProfileState> emit) async {
    bool language = await SharedData.getToken("language");
        emit(GetPostSuccessState(
            listOfPosts:event.listOfData,
            listOfFutureData: event.allPrevPostData,
          language: language
        ));
  }
}
