import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/SignInBloc/sign_in_event.dart';
import 'package:neuralcode/Bloc/AuthBloc/SignInBloc/sign_in_state.dart';
import '../../../Repositories/AuthRepo/sign_up_repo.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<LoginEvent>(loginEvent);
  }

  FutureOr<void> loginEvent(
      LoginEvent event, Emitter<SignInState> emit) async {
   if(event.isValidEmail){
     emit(SignInLoadingState());
     try{
       var result = await AuthRepo.signInUser(
         email: event.email,
       );
       if(result == "success"){
         emit(SignInSuccessState());
         emit(SignInInitial());
       }
       else if(result == "email not exist"){
         emit(SignInInitial());
         emit(InvalidEmailState());
       }else{
         emit(SignInErrorState());
       }
     }
     catch(error){
       emit(SignInErrorState());
     }
   }
   else{
     emit(InvalidEmailState());
   }
  }
}
