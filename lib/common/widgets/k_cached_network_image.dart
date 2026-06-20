// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shimmer/shimmer.dart';

// class KCachedNetworkImage extends StatelessWidget {
//   final String imageUrl;
//   final double? radius;

//   const KCachedNetworkImage({super.key, required this.imageUrl, this.radius});

//   @override
//   Widget build(BuildContext context) {
//     final imageContainerHeight = 300.h;
//     final imageContainerWidth = 200.w;
//     final containerBorderRadius = BorderRadius.circular(2.r);
//     return CachedNetworkImage(
//       imageUrl: imageUrl,
//       imageBuilder: (context, imageProvider) => Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(radius ?? 8.r),
//           image: DecorationImage(
//             image: imageProvider,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//       placeholder: (context, url) => Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[200]!,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.grey.shade100,
//             borderRadius: containerBorderRadius,
//           ),
//           width: imageContainerWidth,
//           height: imageContainerHeight,
//         ),
//       ),
//       errorWidget: (context, url, error) => Container(
//         decoration: BoxDecoration(
//             color: Colors.grey.shade200, borderRadius: containerBorderRadius),
//         height: imageContainerHeight,
//         width: imageContainerWidth,
//         child: const Icon(Icons.error),
//       ),
//     );
//   }
// }
