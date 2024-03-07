import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/UserDetailsBloc/user_details_state.dart';
import '../../../Api/all_api.dart';
import '../../../SharedPrefernce/shared_pref.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(UserDetailsInitial());

  Future getUserDetails()async{
    emit(UserDetailsLoadingState());
    try{
      String name = await SharedData.getEmail("name");
      print(name);
      String userNameData = await SharedData.getEmail("username");
      String profilePic = await SharedData.getEmail("profilePic");
      String imageUrl = "${AllApi.getProfilePic}$name/$profilePic";
      emit(UserDetailsSuccessState(
        name: name,
        userName: userNameData,
        profilePic: profilePic,
        imageUrl: imageUrl
      ));
    }
    catch(error){
      emit(UserDetailsErrorState());
    }
  }
}
