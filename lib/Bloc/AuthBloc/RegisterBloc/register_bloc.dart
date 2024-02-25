import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/RegisterBloc/register_event.dart';
import 'package:neuralcode/Bloc/AuthBloc/RegisterBloc/register_state.dart';
import 'package:neuralcode/Repositories/AuthRepo/sign_up_repo.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial(isUsernameValid: false)) {
    on<RegisterDataEvent>(registerDataEvent);
    on<SendOtp>(sendOtp);
  }
  FutureOr<void> registerDataEvent(
      RegisterDataEvent event, Emitter<RegisterState> emit) async {
    if(event.isUsernameValid){
      emit(RegisterLoadingState());
      try{
        var result = await AuthRepo.registerUserData(
            fullName: event.name,
            email: event.email,
            gender: event.gender,
            age: event.age,
            username: event.username
        );
        if(result == "success" ){
          emit(RegistrationSuccessFullState(email: event.email));
        }
        else{
          emit(ErrorState());
        }
      }
      catch(error){
        emit(ErrorState());
      }
    }else{
      emit(UsernameInvalidState());
    }
  }

  FutureOr<void> sendOtp(
      SendOtp event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingState());
      try{
        var result = await AuthRepo.signInUser(
          email: event.email,
        );
        if(result == "success"){
          emit(OtpSendState(email: event.email));
        }
        else{
          emit(ErrorState());
        }
      }
      catch(error){
        emit(ErrorState());
      }
    }
}
