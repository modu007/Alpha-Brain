import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/ProfileBloc/profile_event.dart';
import 'package:neuralcode/Bloc/ProfileBloc/profile_state.dart';
import 'package:neuralcode/Models/bookmark_post_model.dart';
import '../../Repositories/ProfileRepo/profile_repo.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<GetPostInitialEvent>(getPostInitialEvent);
    on<TabChangeEvent>(tabChangeEvent);
    on<PaginationEvent>(paginationEvent);
    on<UploadPhotoEvent>(uploadPhotoEvent);
  }
  FutureOr<void> getPostInitialEvent(
      ProfileEvent event, Emitter<ProfileState> emit) async {
    emit(GetPostLoadingState());
    try{
      var result = await ProfileRepo.getAllBookmarksData(skip: 0, limit: 5);
      if(result is List<BookmarkPostModel>){
        emit(GetPostSuccessState(listOfPosts:result,listOfFutureData: null));
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
        var result = await ProfileRepo.getAllBookmarksData(skip: 0, limit: 5);
        if(result is List<BookmarkPostModel>){
          emit(GetPostSuccessState(listOfPosts:result,listOfFutureData: null));
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
        var result = await ProfileRepo.getAllLikesData(skip: 0, limit: 5);
        if(result is List<BookmarkPostModel>){
          emit(GetPostSuccessState(listOfPosts:result,listOfFutureData: null));
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
        result = await ProfileRepo.getAllBookmarksData(
            skip: event.skip, limit: event.limit);
      }
      else{
        result = await ProfileRepo.getAllLikesData(
            skip: event.skip, limit: event.limit);
      }
      if(result is List<BookmarkPostModel>){
        List<BookmarkPostModel> allPostData = event.allPrevPostData;
        List<BookmarkPostModel>? listOfFutureData=[];
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
            listOfFutureData: listOfFutureData));
      }else{
        emit(GetPostFailureState(errorMessage: "Error"));
      }
    }
    catch(error){
      emit(GetPostFailureState(errorMessage: "Something went wrong"));
    }
  }

  Future uploadPhotoEvent(
      UploadPhotoEvent event, Emitter<ProfileState> emit) async {
    emit(UploadProfileLoadingState());
   try{
     FilePickerResult? result = await FilePicker.platform.pickFiles(
       type: FileType.custom,
       dialogTitle: "Select Profile Photo",
       allowMultiple: false,
       allowedExtensions: ['jpg', 'jpeg', 'png'],
     );
     if (result != null) {
       PlatformFile file = result.files.first;
       var resultData = await ProfileRepo.uploadProfile(image: file);
       if (resultData["Status"] == "success"&& resultData["Message"]=="Uploaded successfully"){
         emit(UploadProfileSuccessState());
       }
       else {
         emit(UploadProfileSuccessState());
       }
     }
   }
   catch(e){
     emit(UploadProfileErrorState());
   }
  }
}
