import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/register_event.dart';
import 'package:neuralcode/Bloc/AuthBloc/register_state.dart';
import 'package:neuralcode/Repositories/AuthRepo/SignUpRepo.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterDataEvent>(registerDataEvent);
  }
  FutureOr<void> registerDataEvent(
      RegisterDataEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingState());
    try{
      var result = await AuthRepo.registerUserData(
          fullName: event.name,
          email: event.email,
          gender: event.gender,
          age: event.age);
      if(result == "success" ){
        emit(RegistrationSuccessFullState());
      }else{
        emit(ErrorState());
      }
    }
    catch(error){
      emit(ErrorState());
    }
  }
}
