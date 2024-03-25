import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neuralcode/Bloc/TagsBloc/tags_state.dart';
import 'package:neuralcode/Utils/Data/local_data.dart';
import '../../Api/all_api.dart';
import '../../NetworkRequest/network_request.dart';

class TagsCubit extends Cubit<TagsState> {
  TagsCubit() : super(TagsInitial());

  Future getTags()async{
    NetworkRequest networkRequest = NetworkRequest();
    try {
      var result = await networkRequest
          .postMethodRequest({
        "Email": "satishlangayan@gmail.com"
      },AllApi.getTags);
      LocalData.getTags.clear();
      if(result is List){
        LocalData.getTags.addAll(result);
      }else{
        emit(TagsError());
      }
    } catch (error) {
      emit(TagsError());
    }
  }
}
