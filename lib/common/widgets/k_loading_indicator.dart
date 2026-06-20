import 'package:flutter/material.dart';

Widget kLoadingIndicator(
    {required BuildContext context, Color? background, double? strockWidth}) {
  return Center(
    child: CircularProgressIndicator.adaptive(
      backgroundColor: background,
    ),
  );
}
