import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Models/for_you_model.dart';
import 'package:neuralcode/SharedPrefernce/shared_pref.dart';
import '../../Repositories/HomeRepo/home_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(GetPostInitialState()) {
    on<GetHomePostInitialEvent>(getPostInitialEvent);
    on<TabChangeEvent>(tabChangeEvent);
    on<PaginationEvent>(paginationEvent);
    on<HomePostLikeEvent>(postLikeEvent);
    on<HomeBookmarkPostEvent>(bookmarkPostEvent);
    on<AdminActionEvent>(adminActionEvent);
    on<TagSelectedEvent>(tagSelectedEvent);
    on<LanguageChange>(languageChange);
  }

  FutureOr<void> getPostInitialEvent(
      GetHomePostInitialEvent event, Emitter<HomeState> emit) async {
    emit(GetPostLoadingState());
    try{
      var result = await HomeRepo.getAllPostDataOfForYou(
          skip: 0,
          limit: 5,
        selectedTag: event.selectedTag
      );
      await HomeRepo.activeUser();
      if(result is List<ForYouModel>){
        String email =await SharedData.getEmail("email");
        print(email);
        bool isAdmin =false;
        if(email == "satishlangayan@gmail.com"||email=="rangashubham1108@gmail.com"){
          isAdmin=true;
        }
        bool? language = await SharedData.getToken("language");
        if(language == null){
          SharedData.language(false);
        }
        emit(GetPostSuccessState(
            listOfPosts:result,isAdmin: isAdmin,
            selectedTag: event.selectedTag,
          languageChange: language!,
            listOfFutureData: null
        ));
      }
      else{
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
            skip: 0, limit: 5,
          selectedTag: event.selectedTag,
          isMyTags: event.selectedTag =="My tags"?true:null
        );
        if(result is List<ForYouModel>){
          String email =await SharedData.getEmail("email");
          bool isAdmin =false;
          if(email == "satishlangayan@gmail.com"||email=="rangashubham1108@gmail.com"){
            isAdmin=true;
          }
          bool language = await SharedData.getToken("language");
          emit(GetPostSuccessState(
              listOfPosts:result,isAdmin: isAdmin,
              selectedTag: event.selectedTag,
            languageChange: language,
              listOfFutureData: null
          ));
        }else{
          emit(GetPostFailureState(errorMessage: "Error"));
        }
      }
      catch(error){
        emit(GetPostFailureState(errorMessage: "Something went wrong"));
      }
    }
    else if (event.tabIndex==1){
      try{
        var result = await HomeRepo.getAllPostDataOfTopPicks(
            skip: 0, limit: 5, selectedTag: event.selectedTag);
        if(result is List<ForYouModel>){
          String email =await SharedData.getEmail("email");
          bool isAdmin =false;
          if(email == "satishlangayan@gmail.com"||email=="rangashubham1108@gmail.com"){
            isAdmin=true;
          }
          bool language = await SharedData.getToken("language");
          emit(GetPostSuccessState(
              listOfPosts:result,isAdmin: isAdmin,
              selectedTag: event.selectedTag,
            languageChange: language,
              listOfFutureData: null
          ));
        }else{
          emit(GetPostFailureState(errorMessage: "Error"));
        }
      }
      catch(error){
        emit(GetPostFailureState(errorMessage: "Something went wrong"));
      }
      }
    else{
      //my tags
      try{
        var result = await HomeRepo.getAllMyTagsFeed(
            skip: 0, limit: 5, selectedTag: event.selectedTag);
        if(result is List<ForYouModel>){
          String email =await SharedData.getEmail("email");
          bool isAdmin =false;
          if(email == "satishlangayan@gmail.com"||email=="rangashubham1108@gmail.com"){
            isAdmin=true;
          }
          bool language = await SharedData.getToken("language");
          emit(GetPostSuccessState(
              listOfPosts:result,isAdmin: isAdmin,
              selectedTag: event.selectedTag,
              languageChange: language,
            listOfFutureData: null
          ));
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
          //for you
           result = await HomeRepo.getAllPostDataOfForYou(
            skip: event.skip,
            limit: event.limit,
            selectedTag: event.selectedTag);
      }
        else if (event.tab==1){
          //top picks
           result = await HomeRepo.getAllPostDataOfTopPicks(
            skip: event.skip,
            limit: event.limit,
            selectedTag: event.selectedTag);
      }else if(event.tab ==2){
          //anime economy
          result = await HomeRepo.getAllPostDataOfForYouMyTags(
              skip: event.skip,
              limit: event.limit,
              selectedTag: event.selectedTag,
              tags: [event.selectedTag]);
        }
        else{
          // getAllMyTagsFeed my tags
          result = await HomeRepo.getAllMyTagsFeed(
              skip: event.skip,
              limit: event.limit,
              selectedTag: event.selectedTag,
          );
        }
        if(result is List<ForYouModel>){
          List<ForYouModel>? listOfFutureData=[];
          List<ForYouModel> allPostData = event.allPrevPostData;
          List<ForYouModel> resultData =[];
          if(result.isNotEmpty) {
            listOfFutureData = null;
          }
          resultData.addAll(result);
          result.clear();
          result.addAll(allPostData);
          result.addAll(resultData);
          String email =await SharedData.getEmail("email");
          bool language = await SharedData.getToken("language");
          bool isAdmin =false;
          if(email == "satishlangayan@gmail.com"||email=="rangashubham1108@gmail.com"){
            isAdmin=true;
          }
          emit(GetPostSuccessState(
              listOfFutureData: listOfFutureData,
              listOfPosts:result,isAdmin: isAdmin,
              selectedTag: event.selectedTag,
            languageChange: language
          ));
        }else{
          emit(GetPostFailureState(errorMessage: "Error"));
        }
      }
      catch(error){
        emit(GetPostFailureState(errorMessage: "Something went wrong"));
      }
  }

  FutureOr<void> postLikeEvent(
      HomePostLikeEvent event, Emitter<HomeState> emit) async {
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
    if(event.postData.myEmojis!.isEmpty){
      if(loveCount == null){
        loveCount =1;
      }else{
        loveCount = loveCount+1;
      }
      data.insert(index, ForYouModel(
        shortUrl: event.postData.shortUrl,
        summaryHi: event.postData.summaryHi,
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
        shortUrl: event.postData.shortUrl,
        summaryHi: event.postData.summaryHi,
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
    bool language = await SharedData.getToken("language");
    bool isAdmin =false;
    if(email == "satishlangayan@gmail.com"||email=="rangashubham1108@gmail.com"){
      isAdmin=true;
    }
    emit(GetPostSuccessState(
        listOfFutureData: event.listOfFutureData,
        listOfPosts:data,isAdmin: isAdmin,
        selectedTag: event.selectedTag,
      languageChange: language
    ));
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
      HomeBookmarkPostEvent event, Emitter<HomeState> emit) async {
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
          shortUrl: event.postData.shortUrl,
          summaryHi: event.postData.summaryHi,
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
          summaryHi: event.postData.summaryHi,
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
          myBookmark: [],
        shortUrl: event.postData.shortUrl
      ));
    }
    String email =await SharedData.getEmail("email");
    bool isAdmin =false;
    if(email == "satishlangayan@gmail.com"||email=="rangashubham1108@gmail.com"){
      isAdmin=true;
    }
    bool language = await SharedData.getToken("language");
    emit(GetPostSuccessState(
        listOfFutureData: event.listOfFutureData,
        listOfPosts:data,isAdmin: isAdmin,
        selectedTag: event.selectedTag,
      languageChange: language
    ));
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
    bool language = await SharedData.getToken("language");
    bool isAdmin =false;
    if(email == "satishlangayan@gmail.com"|| email=="rangashubham1108@gmail.com"){
      isAdmin=true;
    }
   emit(GetPostSuccessState(
       listOfFutureData: event.listOfFutureData,
       listOfPosts: data, isAdmin: isAdmin,
       selectedTag: event.selectedTag,
     languageChange: language
   ));
    try{
      await HomeRepo.adminAction(
          postId: event.postData.id,
      );
    }
    catch(error){
      emit(GetPostFailureState(errorMessage: "Something went wrong"));
    }
  }

  FutureOr<void> tagSelectedEvent(
      TagSelectedEvent event, Emitter<HomeState> emit) async {
    emit(GetPostLoadingState());
      try{
        var result = await HomeRepo.getAllPostDataOfForYouMyTags(
            skip: 0, limit: 5,
            selectedTag: event.selectedTag,
          tags: [event.selectedTag.toLowerCase()],
        );
        if(result is List<ForYouModel>){
          String email =await SharedData.getEmail("email");
          bool isAdmin =false;
          if(email == "satishlangayan@gmail.com" || email=="rangashubham1108@gmail.com"){
            isAdmin=true;
          }
          bool language = await SharedData.getToken("language");
          emit(GetPostSuccessState(
              listOfFutureData: null,
              listOfPosts:result,isAdmin: isAdmin,
              selectedTag: event.selectedTag,
            languageChange: language
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
      LanguageChange event, Emitter<HomeState> emit) async {
    emit(GetPostLoadingState());
    bool isAdmin =false;
    String email =await SharedData.getEmail("email");
    SharedData.language(event.language==true?true:false);
    if(email == "satishlangayan@gmail.com"||email=="rangashubham1108@gmail.com"){
      isAdmin=true;
    }
    List<ForYouModel> data = event.listOfPost;
    emit(GetPostSuccessState(
      listOfFutureData: event.listOfFutureData,
        listOfPosts: data,
        isAdmin: isAdmin,
        selectedTag: event.selectedTag,
        languageChange: event.language,
    ));
    try{
      await HomeRepo.changeLanguage(language: event.language==true?"hi":"en");
    }
    catch(e){
      emit(GetPostFailureState(errorMessage: "Something went wrong"));
    }
  }
}
