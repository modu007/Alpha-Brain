import 'package:file_picker/file_picker.dart';
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
    try {
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

    try {
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

  static Future removeBookmarkPost(
      {
        required String postId,
        required bool bookmark
      }) async {
    NetworkRequest networkRequest = NetworkRequest();
    String email = await SharedData.getEmail("email");

    try {
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
    try {
      FormData formData = FormData.fromMap(
        {
          'image': await MultipartFile.fromFile(image.path.toString(),
              filename: image.name),
          "Email":email,
          "Name":"Harshit"
        },
      );
      return networkRequest.postDioRequest(AllApi.uploadImage, formData);
    } catch (e) {
      print("User repo: $e");
      return e.toString();
    }
  }
}
