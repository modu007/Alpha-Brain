import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/UsernameCubit/username_state.dart';
import '../../../Repositories/AuthRepo/sign_up_repo.dart';

class UsernameCubit extends Cubit<UsernameState> {
  UsernameCubit() : super(UsernameInitial());

  Future usernameAvailability(String username)async{
    emit(UsernameLoading());
    try{
      var result = await AuthRepo.userAvailability(userName: username);
      if(result == "success" ){
        emit((UsernameSuccessState(isUsernameValid: true)));
      }else if(result =="exists"){
        emit(UsernameExistsState(isUsernameValid: false));
      }else{
        emit(UsernameErrorState());
      }
    }
    catch(error){
      emit(UsernameErrorState());
    }
  }

  Future userInitialEvent()async{
    emit(UsernameInitial());
  }
}
