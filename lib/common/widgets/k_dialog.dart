import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_theme.dart';
import '../constant/app_dimens.dart';
import '../constant/ui_helpers.dart';
import 'k_loading_indicator.dart';
import 'k_material_button.dart';

Future<void> kDialogBox(
  BuildContext context, {
  String? conformText,
  bool? isloading,
  bool? showCancel = false,
  String? lottiAnimation,
  String? message,
  TextAlign? messageTextAlign,
  Color? customButtonColor,
  final void Function()? onKeyPressed,
  final String? heading,
}) async {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return IosDialogBoxContent(
          conformText: conformText,
          customButtonColor: customButtonColor,
          lottiAnimation: lottiAnimation,
          message: message,
          messageTextAlign: messageTextAlign,
          heading: heading,
          showCancel: showCancel,
          isloading: isloading,
          onKeyPressed: onKeyPressed,
        );
      },
    );
  } else {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogBoxContent(
          conformText: conformText,
          customButtonColor: customButtonColor,
          lottiAnimation: lottiAnimation,
          message: message,
          heading: heading,
          messageTextAlign: messageTextAlign,
          showCancel: showCancel,
          isloading: isloading,
          onKeyPressed: onKeyPressed,
        );
      },
    );
  }
}

class DialogBoxContent extends StatefulWidget {
  final String? conformText;
  final bool? showCancel;
  final String? lottiAnimation;
  final bool? isloading;
  final String? message;
  final Color? customButtonColor;
  final void Function()? onKeyPressed;
  final String? heading;
  final TextAlign? messageTextAlign;

  const DialogBoxContent(
      {super.key,
      required this.conformText,
      this.isloading,
      this.showCancel,
      this.messageTextAlign,
      required this.lottiAnimation,
      required this.message,
      required this.customButtonColor,
      this.onKeyPressed,
      this.heading});

  @override
  State<DialogBoxContent> createState() => _DialogBoxContentState();
}

class _DialogBoxContentState extends State<DialogBoxContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8).r),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(20).dg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.heading != null)
                  Text(
                    widget.heading ?? '',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                lHeightSpan,
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0).dg,
                  child: Text(
                    textAlign: widget.messageTextAlign ?? TextAlign.center,
                    widget.message ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: AppDimens.headlineFontSizeXSmall,
                        ),
                  ),
                ),
                lHeightSpan,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.showCancel == true)
                      KMaterialButton(
                        height: 45.h,
                        textColor: secondaryColor,
                        // color: disabledColor,
                        onKeyPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    mWidthSpan,
                    sWidthSpan,
                    KMaterialButton(
                      height: 45.h,
                      textColor: Colors.white,
                      color: widget.customButtonColor ?? primaryColor,
                      onKeyPressed: widget.onKeyPressed,
                      child: Text(
                        widget.conformText ?? "Confirm",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                    if (widget.isloading == true)
                      SizedBox(
                        height: 15.h,
                        width: 15.w,
                        child: kLoadingIndicator(context: context),
                      )
                  ],
                ),
                sHeightSpan,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IosDialogBoxContent extends StatefulWidget {
  final String? conformText;
  final bool? showCancel;
  final String? lottiAnimation;
  final bool? isloading;
  final String? message;
  final Color? customButtonColor;
  final void Function()? onKeyPressed;
  final String? heading;
  final TextAlign? messageTextAlign;

  const IosDialogBoxContent(
      {super.key,
      required this.conformText,
      this.isloading,
      this.showCancel,
      this.messageTextAlign,
      required this.lottiAnimation,
      required this.message,
      required this.customButtonColor,
      this.onKeyPressed,
      this.heading});

  @override
  State<IosDialogBoxContent> createState() => _IosDialogBoxContentState();
}

class _IosDialogBoxContentState extends State<IosDialogBoxContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: CupertinoAlertDialog(
          title: widget.heading != null
              ? Text(
                  widget.heading ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                      ),
                )
              : null,
          content: Text(
            textAlign: widget.messageTextAlign ?? TextAlign.center,
            widget.message ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: AppDimens.headlineFontSizeXSmall,
                ),
          ),
          actions: [
            if (widget.showCancel == true)
              CupertinoDialogAction(
                child: Text(
                  "Cancel",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            CupertinoDialogAction(
              child: Text(
                widget.conformText ?? "Confirm",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: widget.customButtonColor ?? Colors.black),
              ),
              onPressed: () => widget.onKeyPressed?.call(),
            ),
          ],
        ),
      ),
    );
  }
}
