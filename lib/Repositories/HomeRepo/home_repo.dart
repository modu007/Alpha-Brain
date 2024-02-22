import 'package:neuralcode/Models/for_you_model.dart';
import '../../Api/all_api.dart';
import '../../NetworkRequest/network_request.dart';

class HomeRepo {
  static Future getAllPostDataOfForYou(
      {required String email, required int skip,required int limit}) async {
    NetworkRequest networkRequest = NetworkRequest();
    try {
      var result = await networkRequest.postMethodRequest({
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
      var result = await networkRequest.postMethodRequest({
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

  static Future reactionOnPost(
      {
        required String email,
        required String postId,
        required String previousEmojiType,
        required String emojisType,
      }) async {
    NetworkRequest networkRequest = NetworkRequest();
    try {
      var result = await networkRequest.postMethodRequest({
        "Email": email,
        "Post_id": postId,
        "Emojis_type": emojisType,
        "Previous_emojis_type": previousEmojiType
      },
          AllApi.reactionOnPost);
      print("ressss:$result");
      if(result["Status"]=="Success"){
        return "success";
      }
      return "something went wrong";
    } catch (error) {
      print("sign up repo $error");
    }
  }
}
