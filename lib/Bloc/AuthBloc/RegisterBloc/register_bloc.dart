import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/RegisterBloc/register_event.dart';
import 'package:neuralcode/Bloc/AuthBloc/RegisterBloc/register_state.dart';
import 'package:neuralcode/Repositories/AuthRepo/sign_up_repo.dart';

import '../../../SharedPrefernce/shared_pref.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial(isUsernameValid: false)) {
    on<RegisterDataEvent>(registerDataEvent);
    on<SendOtp>(sendOtp);
    on<TermsAndConditionEvent>(termsAndConditionEvent);
  }
  FutureOr<void> registerDataEvent(
      RegisterDataEvent event, Emitter<RegisterState> emit) async {
    if (event.fullNameValid) {
      if (event.isEmailValid) {
        if (event.dob) {
          if (event.isUsernameValid) {
            emit(RegisterLoadingState());
            SharedData.language(event.language == "Hindi" ? true : false);
            try {
              var result = await AuthRepo.registerUserData(
                  fullName: event.name,
                  email: event.email,
                  gender: event.gender,
                  age: event.age,
                  username: event.username,
                  language: event.language == "Hindi" ? "hi" : "en");
              if (event.isGoogleSignIn) {
                await AuthRepo.otpVerification(
                    email: event.email, otp: "gmail_verified");
              }
              if (result == "success") {
                emit(RegistrationSuccessFullState(email: event.email));
              } else {
                emit(ErrorState());
              }
            } catch (error) {
              emit(ErrorState());
            }
          } else {
            emit(UsernameInvalidState());
          }
        } else {
          emit(DobInvalidState());
        }
      } else {
        emit(EmailInvalidState());
      }
    } else {
      emit(FullNameInvalidState());
    }
  }

  FutureOr<void> sendOtp(SendOtp event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingState());
    try {
      var result = await AuthRepo.signInUser(
        email: event.email,
      );
      if (result == "success") {
        emit(OtpSendState(email: event.email));
      } else {
        emit(ErrorState());
      }
    } catch (error) {
      emit(ErrorState());
    }
  }

  FutureOr<void> termsAndConditionEvent(
      TermsAndConditionEvent event, Emitter<RegisterState> emit) async {
    try {
      await AuthRepo.getTermsAndCondition();
    } catch (error) {
      emit(ErrorState());
    }
  }
}
