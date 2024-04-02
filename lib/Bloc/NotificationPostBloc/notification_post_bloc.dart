import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Models/for_you_model.dart';
import '../../Repositories/NotificationPostRepo/notification_post_repo.dart';
import '../../SharedPrefernce/shared_pref.dart';
import 'notification_post_event.dart';
import 'notification_post_state.dart';

class NotificationPostBloc extends Bloc<NotificationPostEvent, NotificationPostState> {
  NotificationPostBloc() : super(NotificationPostInitial()) {
    on<GetPostInitialEvent>(getPostInitialEvent);
  }

  FutureOr<void> getPostInitialEvent(
      GetPostInitialEvent event, Emitter<NotificationPostState> emit) async {
    emit(NotificationPostLoading());
    try{
      var result = await NotificationRepo.getPostById(
          postId: "660179253cec5e04d8f38199");
      await NotificationRepo.userNotifiedRepo(
          postId: "660179253cec5e04d8f38199");
      if(result is ForYouModel){
        String email =await SharedData.getEmail("email");
        bool isAdmin =false;
        if(email == "satishlangayan@gmail.com"){
          isAdmin=true;
        }
        emit(NotificationPostSuccess(
            listOfPosts:result,
            isAdmin: isAdmin,
        ));
      }else{
        emit(NotificationPostError(errorMessage: "Error"));
      }
    }
    catch(error){
      emit(NotificationPostError(errorMessage: "Something went wrong"));
    }
  }
}
