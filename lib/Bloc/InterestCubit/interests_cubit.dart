import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Repositories/InterestsRepo/interests_repo.dart';
import 'package:neuralcode/SharedPrefernce/shared_pref.dart';
import 'package:neuralcode/Utils/Data/local_data.dart';
import 'interests_state.dart';

class InterestsCubit extends Cubit<InterestsState> {
  InterestsCubit() : super(InterestsInitial());

  Future saveInterest({
    required List<String> customTags,
    required List<String> userInterests
  }) async {
   if(userInterests.length >=2){
     emit(InterestsLoading());
     try{
        var result = await InterestsRepo.saveYourInterests(
            customTags: customTags, userInterests: userInterests);
        if(result == true){
          SharedData.saveInterests(userInterests);
          SharedData.saveCustomInterests(customTags);
          LocalData.getUserInterestsSelected.clear();
          LocalData.getCustomTags.clear();
          LocalData.getUserInterestsSelected.addAll(userInterests);
          LocalData.getCustomTags.addAll(customTags);
         emit(InterestsSaved());
       }else{
         emit(InterestError());
       }
     }
     catch(e){
       emit(InterestError());
     }
   }else{
     emit(AtLeastTwoInterests());
   }
  }
}
