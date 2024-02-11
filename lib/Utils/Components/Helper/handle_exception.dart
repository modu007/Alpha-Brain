// import 'package:flutter/services.dart';
//
// import '../../../NetworkRequest/app_exception.dart';
// import '../../../SharedPrefernce/shared_pref.dart';
// import '../../Routes/navigation_service.dart';
// import 'exception_helper.dart';
//
// class BaseController {
//   NavigationService service = NavigationService();
//
//   handleError(error) {
//     print("error: $error");
//     switch (error) {
//       case BadRequestException():
//         var message = error.message;
//         DialogHelper.showErrorDialog(description: message);
//       case FetchDataException():
//         var message = error.message;
//         DialogHelper.showErrorDialog(description: message);
//       case RequestTimeOutException():
//         DialogHelper.showErrorDialog(
//             description: 'Oops! It took longer to respond.');
//       case InternetException():
//         var title = "Connection Failed";
//         var message = error.message;
//         DialogHelper.showErrorDialog(description: message, title: title);
//       case ServerException():
//         var message = error.message;
//         DialogHelper.showErrorDialog(description: message);
//       case PlatformException():
//         var message = error.code;
//         DialogHelper.showErrorDialog(description: "No Internet Connection");
//       case UnAuthorizedException():
//         SharedData.removeUserid();
//         NavigationService.navigateToSignIn();
//       default:
//         DialogHelper.showErrorDialog(description: "Invalid Request");
//     }
//   }
// }
