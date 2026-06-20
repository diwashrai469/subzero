// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:travel_nepal/common/constant/ui_helpers.dart';
// import 'package:travel_nepal/theme/app_theme.dart';

// Widget kTextFomFieldForDate({
//   required TextEditingController controller,
//   required BuildContext context,
//   String? label,
//   bool? isRequired,
//   String? hint,
// }) {
//   return Column(
//     children: [
//       if (label != null && label.isNotEmpty)
//         Column(
//           children: [
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Row(
//                 children: [
//                   Text.rich(
//                     TextSpan(
//                       text: label,
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                             fontWeight: FontWeight.w600,
//                           ),
//                       children: <InlineSpan>[
//                         if (isRequired == true)
//                           const TextSpan(
//                             text: '* ',
//                             style: TextStyle(color: Colors.red),
//                           )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             sHeightSpan
//           ],
//         ),
//       GestureDetector(
//         onTap: () {
//           _selectDate(context, controller);
//         },
//         child: AbsorbPointer(
//           child: TextFormField(
//             controller: controller,
//             style: Theme.of(context).textTheme.bodyMedium,
//             decoration: InputDecoration(
//               suffixIcon: const Icon(
//                 Icons.calendar_month,
//                 color: Colors.grey,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(const Radius.circular(10).r),
//                 borderSide: const BorderSide(
//                   color: Colors.grey,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10).r,
//                 borderSide: const BorderSide(color: primaryColor),
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10).r,
//               ),
//               hintText: hint ?? "Seletect date",
//               hintStyle: Theme.of(context)
//                   .textTheme
//                   .bodyMedium
//                   ?.copyWith(color: Colors.grey),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }

// void _selectDate(BuildContext context, TextEditingController controller) {
//   DateTime currentDate = DateTime.now();

//   if (controller.text.isNotEmpty) {
//     try {
//       currentDate = DateTime.parse(controller.text);
//     } catch (e) {
//       if (kDebugMode) {
//         print('Invalid date format in controller: ${controller.text}');
//       }
//     }
//   }

//   final localContext = context;

//   showDatePicker(
//     builder: (context, child) {
//       return Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: const ColorScheme.light(
//             primary: primaryColor,
//             onPrimary: Colors.white,
//             onSurface: Colors.black,
//           ),
//           textButtonTheme: TextButtonThemeData(
//             style: TextButton.styleFrom(
//               foregroundColor: primaryColor,
//             ),
//           ),
//         ),
//         child: child!,
//       );
//     },
//     context: localContext,
//     initialDate: currentDate,
//     firstDate: DateTime(1900),
//     lastDate: DateTime(2100),
//   ).then((picked) {
//     final DateTime selectedDate = DateTime(
//       picked!.year,
//       picked.month,
//       picked.day,
//     );

//     final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

//     controller.text = formattedDate;
//   });
// }
