import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:neuralcode/Utils/Data/local_data.dart';
import '../../Api/all_api.dart';
import '../../NetworkRequest/network_request.dart';
import '../../SharedPrefernce/shared_pref.dart';

class InterestsRepo{
  static Future saveYourInterests(
      {required List customTags,
        required List userInterests}) async {
    NetworkRequest networkRequest = NetworkRequest();
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);
    String email =await SharedData.getEmail("email");
    try {
      if(hasExpired){
        var res = await networkRequest.refreshToken({}, AllApi.generateToken);
        if(res["Token"]!= null){
          SharedData.setToken(res["Token"]);
        }
      }
      var result = await networkRequest.postMethodRequest({
        "email": email,
        "Custom_tags":customTags,
        "User_interest": userInterests
      }, AllApi.saveInterests);
      if(result["status"]==true){
        return true;
      }else{
        return false;
      }
    } catch (error) {
      return error;
    }
  }

  static Future getYourInterests() async {
    NetworkRequest networkRequest = NetworkRequest();
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);
    String email =await SharedData.getEmail("email");
    try {
      if(hasExpired){
        var res = await networkRequest.refreshToken({}, AllApi.generateToken);
        if(res["Token"]!= null){
          SharedData.setToken(res["Token"]);
        }
      }
      var result = await networkRequest.postMethodRequest({
        "email": email
      }, AllApi.getInterests);
      print(result);
      if(result["status"]=="interest_does_not_exists"){
        LocalData.getCustomTags.clear();
        LocalData.getUserInterestsSelected.clear();
        LocalData.getInterests.clear();
        List<String> interests =[];
        for(int i=0; i <result["user_interest"].length;i++){
          interests.add(result["user_interest"][i]);
        }
        //new user
       LocalData.getInterests.addAll(interests);
       //add custom tags also
        //todo
        return true;
      }else{
        //old user
        LocalData.getCustomTags.clear();
        LocalData.getUserInterestsSelected.clear();
        List<String> interests =[];
        List<String> customTags =[];
        print(result);
        for(int i=0; i <result["user_interest"].length;i++){
          interests.add(result["user_interest"][i]);
        }
        for(int i=0; i <result["user_custom_tags"].length;i++){
          customTags.add(result["user_custom_tags"][i]);
        }
        SharedData.removeUserid("custom");
        SharedData.removeUserid("interests");
        LocalData.getCustomTags.addAll(customTags);
        LocalData.getUserInterestsSelected.addAll(interests);
        print("local data");
        print(LocalData.getCustomTags);
        print(LocalData.getInterests);
        print(LocalData.getUserInterestsSelected);
        print("here");
        print(await SharedData.getToken("interests"));
        SharedData.saveCustomInterests(LocalData.getCustomTags);
        SharedData.saveInterests(interests);
        print("yes");
        print(await SharedData.getToken("interests"));
        print("hello");
        return false;
      }
    } catch (error) {
      print(error.toString());
    }
  }

  static Future getListOfInterests() async {
    NetworkRequest networkRequest = NetworkRequest();
    var token = await SharedData.getToken("token");
    bool hasExpired = JwtDecoder.isExpired(token);
    String email =await SharedData.getEmail("email");
    try {
      if(hasExpired){
        var res = await networkRequest.refreshToken({}, AllApi.generateToken);
        if(res["Token"]!= null){
          SharedData.setToken(res["Token"]);
        }
      }
      var result = await networkRequest.postMethodRequest({
        "email": email
      }, AllApi.listOfInterests);
      if(result is List){
        LocalData.getInterests.clear();
        for(int i=0;i<result.length;i++){
          LocalData.getInterests.add(result[i]);
        }
        return true;
      }else{
        return false;
      }
    } catch (error) {
      print(error.toString());
    }
  }

}