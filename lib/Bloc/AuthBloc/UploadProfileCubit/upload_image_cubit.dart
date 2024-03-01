import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/AuthBloc/UploadProfileCubit/upload_image_state.dart';
import '../../../Repositories/ProfileRepo/profile_repo.dart';
import '../../../SharedPrefernce/shared_pref.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UploadImageInitial());

  Future uploadPhotoEvent() async {
    emit(UploadProfileLoadingState());
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        dialogTitle: "Select Profile Photo",
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        PlatformFile? file =  result.files.first;
        var resultData = await ProfileRepo.uploadProfile(image: file);
        print(resultData);
        if (resultData["Status"] == "success"&& resultData["Message"]=="Uploaded successfully")
        {
          SharedData.setProfilePic(resultData["Display_pic"]);
          emit(UploadProfileSuccessState(
              path: file.path
          ));
        }
        else {
          emit(UploadProfileSuccessState(
              path: null
          ));
          emit(CouldNotUploadImageState());
        }
      }
      else{
        emit(UploadProfileSuccessState(
            path: null
        ));
      }
    }
    catch(e){
      emit(UploadProfileErrorState());
    }
  }
}
