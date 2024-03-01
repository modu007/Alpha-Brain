import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Repositories/ProfileRepo/profile_repo.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  Future editProfile(String name,String age )async{
    try{
      emit(EditProfileLoadingState());
      var result = await ProfileRepo.editProfile(name: name,age: age);
      if(result == "success" ){
        emit(EditProfileSuccessState());
      }
      else{
        emit(EditProfileErrorState());
      }
    }
    catch(error){
      emit(EditProfileErrorState());
    }
  }
}
