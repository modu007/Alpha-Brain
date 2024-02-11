import 'package:neuralcode/Models/for_you_model.dart';
import '../../Api/all_api.dart';
import '../../NetworkRequest/network_request.dart';

class HomeRepo {
  static Future getAllPostDataOfForYou(
      {required String email, required int skip,required int limit}) async {
    NetworkRequest networkRequest = NetworkRequest();
    try {
      var result = await networkRequest.postRequest({
        "Email": email,
        "Skip": skip,
        "Limit": limit
      }, AllApi.forYou);
      if(result is List){
      List<ForYouModel> data =[];
        for(int i=0;i<result.length;i++){
          data.add(ForYouModel.fromJson(result[i]));
        }
        return data;
      }
      return "something went wrong";
    } catch (error) {
      print("sign up repo $error");
    }
  }

  static Future getAllPostDataOfTopPicks(
      {required String email, required int skip,required int limit}) async {
    NetworkRequest networkRequest = NetworkRequest();
    try {
      var result = await networkRequest.postRequest({
        "Email": email,
        "Skip": skip,
        "Limit": limit
      }, AllApi.topPicks);
      if(result is List){
        List<ForYouModel> data =[];
        for(int i=0;i<result.length;i++){
          data.add(ForYouModel.fromJson(result[i]));
        }
        return data;
      }
      return "something went wrong";
    } catch (error) {
      print("sign up repo $error");
    }
  }
}
