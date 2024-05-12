import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Repositories/InterestsRepo/interests_repo.dart';
import 'package:neuralcode/Utils/Data/local_data.dart';
import 'get_interests_state.dart';

class GetInterestsCubit extends Cubit<GetInterestsState> {
  GetInterestsCubit() : super(GetInterestsInitial());

  Future getAllAndSelectedInterests()async{
    emit(GetInterestsLoading());
    try{
      var result = await InterestsRepo.getListOfInterests();
      await InterestsRepo.getYourInterests();
      if(result==true){
        emit(GetInterestsSuccess(
            listOfInterests: LocalData.getInterests,
            customTags: LocalData.getCustomTags,
            selectedInterests: LocalData.getUserInterestsSelected));
      }
      else{
        emit(GetInterestsError());
      }
    }
    catch(e){
      emit(GetInterestsError());
    }
  }
}
