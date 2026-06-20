import 'package:flutter/material.dart';
import 'package:subzero/theme/app_theme.dart';

void kBottonsheet(
  BuildContext context,
  Widget widget,
  bool isScrollControlled,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    builder: (context) => widget,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    backgroundColor: scaffoldBgColor,
  );
}
