import '../../Api/all_api.dart';
import '../../NetworkRequest/network_request.dart';

class AuthRepo{
  static Future registerUserData({
    required String fullName,
    required String email,
    required String gender,
    required String age}) async {
    NetworkRequest networkRequest = NetworkRequest();
    try {
      var result = await networkRequest
          .postRequest({
        "FullName": fullName,
        "Email": email,
        "Gender": gender,
        "Age": age
      },AllApi.registerUser);
      if(result["Status"]=="success"){
        return "success";
      }else{
        return "details provided are incorrect";
      }
    } catch (error) {
      print("sign up repo $error");
    }
  }
}
