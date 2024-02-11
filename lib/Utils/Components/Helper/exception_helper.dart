// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shopkart/Utils/components/Text/simple_text.dart';
// import 'package:shopkart/main.dart';
//
// class DialogHelper {
//   static void showErrorDialog(
//       {String title = 'Error', String? description = 'Something went wrong'}) {
//     showDialog(
//         context: navigatorKey.currentContext!,
//         builder: (context) {
//           return Dialog(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               margin: const EdgeInsets.symmetric(horizontal: 10),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SimpleText(
//                       text: title, fontColor: Colors.black45, fontSize: 16),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   SimpleText(
//                     text: description ?? '',
//                     fontColor: Colors.black,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: const Text('Okay'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   //show toast
//   //show snack bar
//   //show loading
//   static void showLoading([String? message]) {
//     Get.dialog(
//       Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 8),
//               Text(message ?? 'Loading...'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   //hide loading
//   static void hideLoading() {
//     if (Get.isDialogOpen!) Get.back();
//   }
// }
