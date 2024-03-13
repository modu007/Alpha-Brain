import 'package:file_picker/file_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:neuralcode/Models/bookmark_post_model.dart';
import 'package:neuralcode/SharedPrefernce/shared_pref.dart';
import '../../Api/all_api.dart';
import '../../NetworkRequest/network_request.dart';
import 'package:dio/dio.dart';


class ProfileRepo {
  static Future getAllBookmarksData(
      {required int skip,required int limit}) async {
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
        "Email": email,
        "Skip": skip,
        "Limit": limit
      }, AllApi.getBookmarks);
      if(result is List){
        List<BookmarkPostModel> data =[];
        for(int i=0;i<result.length;i++){
          data.add(BookmarkPostModel.fromJson(result[i]));
        }
        return data;
      }
      return "something went wrong";
    } catch (error) {
      print("on pagination repo $error");
    }
  }

  static Future getAllLikesData(
      {required int skip,required int limit}) async {
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
        "Email": email,
        "Skip": skip,
        "Limit": limit
      }, AllApi.getLikedPosts);
      if(result is List){
        List<BookmarkPostModel> data =[];
        for(int i=0;i<result.length;i++){
          data.add(BookmarkPostModel.fromJson(result[i]));
        }
        return data;
      }
      return "something went wrong";
    } catch (error) {
      print("sign up repo $error");
    }
  }

  static Future removeReactionOnPost(
      {
        required String postId,
        required String previousEmojiType,
        required String emojisType,
      }) async {
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

  static Future removeBookmarkPost(
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
        var res = await networkRequest.refreshToken({}, AllApi.generateToken);
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

  static Future uploadProfile(
      {
        required PlatformFile image
      }) async {
    NetworkRequest networkRequest = NetworkRequest();
    String email = await SharedData.getEmail("email");
    String name = await SharedData.getEmail("name");
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);
    try {
      if(hasExpired){
        var res = await networkRequest.refreshToken({}, AllApi.generateToken);
        if(res["Token"]!= null){
          SharedData.setToken(res["Token"]);
        }
      }
      FormData formData = FormData.fromMap(
        {
          'File': await MultipartFile.fromFile(image.path.toString(),
              filename: name.replaceAll(' ', '').toLowerCase()),
          "Email":email,
          "Name":name
        },
      );
      return networkRequest.postDioRequest(AllApi.uploadImage, formData);
    } catch (e) {
      print("User repo: $e");
      return e.toString();
    }
  }

  static Future editProfile(
      {required String name,required String age}) async {
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
        "Email": email,
        "Name": name,
        "Age": age
      }, AllApi.updateProfile);
      if(result["Status"]=="success"){
        SharedData.setName(name);
        return "success";
      }
      return "something went wrong";
    } catch (error) {
      print("on edit profile $error");
    }
  }


  static Future getProfilePic() async {
    NetworkRequest networkRequest = NetworkRequest();
    String name = await SharedData.getEmail("name");
    String dp = await SharedData.getEmail("profile");
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);
    try {
      if(hasExpired){
        var res = await networkRequest.refreshToken({}, AllApi.generateToken);
        if(res["Token"]!= null){
          SharedData.setToken(res["Token"]);
        }
      }
      var result = await networkRequest.getMethodRequest("${AllApi.getProfilePic}$name/$dp");
      if(result["message"]=="Image 'bottom-img_compressed.jpg' not found."){
        return "something went wrong";
      }else{
        return result;
      }
    } catch (error) {
      print("on edit profile $error");
    }
  }

}
