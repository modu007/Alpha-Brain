// import 'package:http/http.dart' as http;
//
// import '../../NetworkRequest/network_request.dart';
//
// class SignInRepo {
//   static Future signInUserData(
//       http.Client client, String email, String password, String signApi) async {
//     NetworkRequest networkRequest = NetworkRequest();
//     try {
//       var result = await networkRequest
//           .postRequest(
//               client,
//               {
//                 "email": email,
//                 "password": password,
//               },
//               signApi)
//           .catchError(baseController.handleError);
//       print("result $result");
//       return result;
//     } catch (error) {
//       print("sign in exception: $error");
//     }
//   }
//
//   static Future sendEmailOtp(http.Client client, String email) async {
//     NetworkRequest networkRequest = NetworkRequest();
//     BaseController baseController = BaseController();
//
//     try {
//       var result = await networkRequest
//           .postRequest(client, {"email": email}, AllApi.sendEmailOtp)
//           .catchError(baseController.handleError);
//       print("result: $result");
//       return result;
//     } catch (error) {}
//   }
//
//   static Future sendPhoneOtp(http.Client client, String phone) async {
//     NetworkRequest networkRequest = NetworkRequest();
//     BaseController baseController = BaseController();
//
//     try {
//       var result = await networkRequest
//           .postRequest(client, {"phone": phone}, AllApi.sendPhoneOtp)
//           .catchError(baseController.handleError);
//       print("result: $result");
//       return result;
//     } catch (error) {}
//   }
//
//   static Future googleSignIn(
//       {required http.Client client,
//       required String email,
//       required String name,
//       required String googleApi}) async {
//     NetworkRequest networkRequest = NetworkRequest();
//     BaseController baseController = BaseController();
//     try {
//       var result = await networkRequest
//           .postRequest(client, {"email": email}, googleApi)
//           .catchError(baseController.handleError);
//       print("re $result");
//       return result;
//     } catch (error) {
//       print("exception: $error");
//     }
//   }
//
//   static Future forgotPassword(
//       {required http.Client client,
//       required String email,
//       required String forgotPasswordApi}) async {
//     NetworkRequest networkRequest = NetworkRequest();
//     BaseController baseController = BaseController();
//     try {
//       var result = await networkRequest
//           .getRequest(client, "$forgotPasswordApi$email")
//           .catchError(baseController.handleError);
//       return result;
//     } catch (error) {
//       print("exception: $error");
//     }
//   }
// }
