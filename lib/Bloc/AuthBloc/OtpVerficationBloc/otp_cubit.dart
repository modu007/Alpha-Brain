import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Repositories/AuthRepo/sign_up_repo.dart';
import 'otp_state.dart';


class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

   Future addAddress(String otp,String email)async{
    emit(OtpLoadingState());
    try{
      var result =await AuthRepo.otpVerification(email: email,otp: otp);
      if(result == "success"){
        emit(OtpSuccessState());
      }
      else if(result =="otp does not match"){
        emit(OtpInvalidState());
      }
      else{
        print("error state");
        emit(OtpErrorState());
      }
    }
    catch(e){
      print("error state inn otp ");
      emit(OtpErrorState());
    }
  }
}
