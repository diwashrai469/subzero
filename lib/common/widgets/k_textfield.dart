// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:subzero/common/constant/app_image.dart';

// class Ktextfield extends StatelessWidget {
//   final bool isGererating;

//   final TextEditingController? controller;
//   final void Function()? onTap;

//   const Ktextfield({
//     super.key,
//     this.controller,
//     this.onTap,
//     required this.isGererating,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         suffixIcon: GestureDetector(
//           onTap: onTap,
//           child: isGererating
//               ? LottieBuilder.asset(AppImage.chatLoading, height: 50.h)
//               : Container(
//                   margin: Theme.of(context).platform == TargetPlatform.iOS
//                       ? EdgeInsets.only(right: 9.w, top: 3.h, bottom: 3.h)
//                       : EdgeInsets.only(right: 12.w, top: 8.h, bottom: 8.h),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade800,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     CupertinoIcons.up_arrow,
//                     size: Theme.of(context).platform == TargetPlatform.iOS
//                         ? 22.h
//                         : 24.h,
//                   ),
//                 ),
//         ),
//         hintStyle: TextStyle(fontSize: 17.sp),
//         hintText: "  Enter your promt...",
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.grey.shade600),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(color: Colors.grey.shade600),
//         ),
//       ),
//     );
//   }
// }
