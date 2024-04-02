import 'package:jwt_decoder/jwt_decoder.dart';
import '../../Api/all_api.dart';
import '../../Models/for_you_model.dart';
import '../../NetworkRequest/network_request.dart';
import '../../SharedPrefernce/shared_pref.dart';

class NotificationRepo{
  static Future getPostById(
      {required String postId}) async {
    NetworkRequest networkRequest = NetworkRequest();
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);
    try {
      if(hasExpired){
        var res = await networkRequest.refreshToken({}, AllApi.generateToken);
        if(res["Token"]!= null){
          SharedData.setToken(res["Token"]);
        }
      }
      var result = await networkRequest.postMethodRequest({
        "Post_id": postId
      }, AllApi.getNewsById);
      if(result is List){
        print(result[0]);
        return ForYouModel.fromJson(result[0]);
      }
      return "something went wrong";
    } catch (error) {
      print("sss");
      print("on getPostById repo $error");
    }
  }

  static Future userNotifiedRepo({required String postId}) async {
    NetworkRequest networkRequest = NetworkRequest();
    String email = await SharedData.getEmail("email");
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);
    try {
      if(hasExpired){
        var res = await networkRequest.refreshToken({}, AllApi.generateToken);
        if(res["Token"]!= null){
          SharedData.setToken(res["Token"]);
        }
      }
      var result = await networkRequest.postMethodRequest({
        "EmailId": email,
        "PostId": postId
      },
          AllApi.userNotified);
      return result;
    } catch (error) {
      print("activeUser repo $error");
    }
  }
}