// import 'package:http/http.dart' as http;
//
// import '../../Api/all_api.dart';
// import '../../NetworkRequest/network_request.dart';
//
// class SignUpRepo {
//   static Future signUpUserData(http.Client client, String fullName,
//       String phone, String email, String password) async {
//     NetworkRequest networkRequest = NetworkRequest();
//
//     try {
//       var result = await networkRequest
//           .postRequest(client, {"email": email, "phone": phone},
//               AllApi.isAccountExistApi);
//
//       print("sign up repo $result");
//       return result;
//     } catch (error) {
//       print("sign up repo $error");
//     }
//   }
// }
