import 'package:neuralcode/SharedPrefernce/shared_pref.dart';
import '../../Api/all_api.dart';
import '../../NetworkRequest/network_request.dart';

class AuthRepo {
  static Future registerUserData({
    required String fullName,
    required String email,
    required String gender,
    required String age,
    required String username,
    required String language,
  }) async {
    NetworkRequest networkRequest = NetworkRequest();
    try {
      var result = await networkRequest.postMethodRequest({
        "FullName": fullName,
        "Email": email,
        "Gender": gender,
        "Age": age,
        "Username": username,
        "Preferred_language": language
      }, AllApi.registerUser);
      if (result["Status"] == "success") {
        return "success";
      } else {
        return "details provided are incorrect";
      }
    } catch (error) {
      print("sign up repo $error");
    }
  }

  static Future signInUser({
    required String email,
  }) async {
    NetworkRequest networkRequest = NetworkRequest();
    try {
      var result = await networkRequest.postMethodRequest({
        "Email": email,
      }, AllApi.sendOtp);
      if (result["Status"] == "success") {
        return "success";
      } else if (result["Status"] == "failed" &&
          result["Message"] == "Failed to send otp") {
        return "email not exist";
      } else {
        return "details provided are incorrect";
      }
    } catch (error) {
      print("sign up repo $error");
    }
  }

  static Future otpVerification({
    required String otp,
    required String email,
  }) async {
    NetworkRequest networkRequest = NetworkRequest();
    try {
      String? fcmToken = await SharedFcmToken.getFcmToken("fcmToken");
      var result = await networkRequest.postMethodRequest(
          {"Otp": otp, "Email": email, "FCMToken": fcmToken}, AllApi.verifyOtp);
      if (result["Token"] != null) {
        SharedData.setToken(result["Token"]);
        SharedData.setRefreshToken(result["Refresh_Token"]);
        SharedData.setEmail(result["Email"]);
        SharedData.setName(result["Name"]);
        SharedData.setUserName(result["Username"]);
        SharedData.setProfilePic(result["Display_pic"]);
        return "success";
      } else if (result["Status"] == "new_user") {
        return "new_user";
      } else if (result["Status"] == "invalid_otp") {
        return "otp does not match";
      } else {
        return "details provided are incorrect";
      }
    } catch (error) {
      print("sign up repo $error");
    }
  }

  static Future userAvailability({
    required String userName,
  }) async {
    NetworkRequest networkRequest = NetworkRequest();
    try {
      print("${AllApi.userAvailability}$userName");
      var result = await networkRequest
          .getMethodRequest("${AllApi.userAvailability}$userName");
      print(result);
      if (result["Status"] == "username_available") {
        return "success";
      } else if (result["Status"] == "username_exists") {
        return "exists";
      } else {
        return "error";
      }
    } catch (error) {
      print("sign up repo $error");
    }
  }

  static Future getTermsAndCondition() async {
    NetworkRequest networkRequest = NetworkRequest();
    try {
      return await networkRequest.getMethodRequest(AllApi.termsAndCondition);
    } catch (error) {
      print("sign up repo $error");
    }
  }
}
