import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:neuralcode/Models/for_you_model.dart';
import 'package:neuralcode/SharedPrefernce/shared_pref.dart';
import '../../Api/all_api.dart';
import '../../NetworkRequest/network_request.dart';

class HomeRepo {
  static Future getAllPostDataOfForYou(
      {required int skip,required int limit}) async {
    NetworkRequest networkRequest = NetworkRequest();
    String email = await SharedData.getEmail("email");
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);
    print(hasExpired);
    try {
     if(hasExpired){
       var res = await networkRequest.postMethodRequest({}, AllApi.generateToken);
       if(res["Token"]!= null){
         SharedData.setToken(res["Token"]);
       }
     }
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
      print("on pagination repo $error");
    }
  }

  static Future getAllPostDataOfTopPicks(
      {required int skip,required int limit}) async {
    NetworkRequest networkRequest = NetworkRequest();
    String email = await SharedData.getEmail("email");
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);

    try {
      if(hasExpired){
        var res = await networkRequest.postMethodRequest({}, AllApi.generateToken);
        if(res["Token"]!= null){
          SharedData.setToken(res["Token"]);
        }
      }
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
        required String postId,
        required String previousEmojiType,
        required String emojisType,
      }) async {
    NetworkRequest networkRequest = NetworkRequest();
    String email = await SharedData.getEmail("email");
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);
    if(hasExpired){
      var res = await networkRequest.postMethodRequest({}, AllApi.generateToken);
      if(res["Token"]!= null){
        SharedData.setToken(res["Token"]);
      }
    }
    try {
      var result = await networkRequest.postMethodRequest({
        "Email": email,
        "Post_id": postId,
        "Emojis_type": emojisType,
        "Previous_emojis_type": previousEmojiType
      },
          AllApi.reactionOnPost);
      if(result["Status"]=="Success"){
        return "success";
      }
      return "something went wrong";
    } catch (error) {
      print("sign up repo $error");
    }
  }

  static Future bookmarkPost(
      {
        required String postId,
       required bool bookmark
      }) async {
    NetworkRequest networkRequest = NetworkRequest();
    String email = await SharedData.getEmail("email");
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);
    try {
      if(hasExpired){
        var res = await networkRequest.postMethodRequest({}, AllApi.generateToken);
        if(res["Token"]!= null){
          SharedData.setToken(res["Token"]);
        }
      }
      var result = await networkRequest.postMethodRequest({
        "Email": email,
        "Post_id": postId,
        "BookMark": bookmark
      },
          AllApi.bookmarkOnPost);
      if(result["Status"]=="success"&& result["Message"]=="Post bookmarked"){
        return "success";
      }
      else if(result["Status"]=="success" &&
          result["Message"] == "Bookmarked removed"){
        return "removed";
      }
      return "something went wrong";
    } catch (error) {
      print("sign up repo $error");
    }
  }

  static Future adminAction(
      {
        required String postId,
      }) async {
    NetworkRequest networkRequest = NetworkRequest();
    String email = await SharedData.getEmail("email");
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);
    try {
      if(hasExpired){
        var res = await networkRequest.postMethodRequest({}, AllApi.generateToken);
        if(res["Token"]!= null){
          SharedData.setToken(res["Token"]);
        }
      }
      var result = await networkRequest.postMethodRequest({
        "Email": email,
        "Post_id": postId
      },
          AllApi.adminApi);
     return result;
    } catch (error) {
      print("sign up repo $error");
    }
  }
}
