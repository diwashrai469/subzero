import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/widgets/k_loading_indicator.dart';

import '../../theme/app_theme.dart';
import '../constant/app_dimens.dart';
import '../constant/ui_helpers.dart';

enum ButtonSize { small, medium, large, xSmall }

class KButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final ButtonSize size;
  final bool isBusy;
  final bool? bordered;
  final Color? backgroundColor, foregroundColor;

  @override
  const KButton({
    required this.child,
    required this.onPressed,
    this.isBusy = false,
    this.size = ButtonSize.small,
    this.backgroundColor,
    this.foregroundColor,
    this.bordered,
    super.key,
  });

  double getFontSizeBySize(ButtonSize size) {
    switch (size) {
      case ButtonSize.xSmall:
        return AppDimens.buttonFontSizeXSmall;
      case ButtonSize.small:
        return AppDimens.buttonFontSizeSmall;
      case ButtonSize.medium:
        return AppDimens.buttonFontSizeMedium;
      case ButtonSize.large:
        return AppDimens.buttonFontSizeLarge;
    }
  }

  EdgeInsetsGeometry getPaddingBySize(ButtonSize size) {
    switch (size) {
      case ButtonSize.xSmall:
        return AppDimens.buttonPaddingXSmall;
      case ButtonSize.small:
        return AppDimens.buttonPaddingSmall;
      case ButtonSize.medium:
        return AppDimens.buttonPaddingMedium;
      case ButtonSize.large:
        return AppDimens.buttonPaddingLarge;
    }
  }

  double getProgressRadiusByButtonSizeWidth(ButtonSize size) {
    switch (size) {
      case ButtonSize.xSmall:
        return 16.w;
      case ButtonSize.small:
        return 18.w;
      case ButtonSize.medium:
        return 20.w;
      case ButtonSize.large:
        return 22.w;
    }
  }

  double getProgressRadiusByButtonSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.xSmall:
        return 16.h;
      case ButtonSize.small:
        return 18.h;
      case ButtonSize.medium:
        return 20.h;
      case ButtonSize.large:
        return 22.h;
    }
  }

  double getProgressWidthByButtonSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.xSmall:
        return 2.w;
      case ButtonSize.small:
        return 2.w;
      case ButtonSize.medium:
        return 2.w;
      case ButtonSize.large:
        return 3.w;
    }
  }

  /// Button is wrapped inside of theme to change the font-size of the
  /// child text widget based on the size passed.
  ///
  /// The buttons can be wrapped to fit content by Wrapping it inside of Row,
  /// and setting the mainAxisSize: MainAxisSize.min

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.copyWith(
          bodyMedium: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: getFontSizeBySize(size)),
        ),
      ),
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(
              elevation: 0,
              padding: getPaddingBySize(size),
              shadowColor: Colors.white,
              overlayColor: Colors.white,
              splashFactory: NoSplash.splashFactory,
              shape: RoundedRectangleBorder(
                side: (bordered ?? false)
                    ? const BorderSide(color: disabledColor)
                    : BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
              ),
            ).copyWith(
              foregroundColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                return foregroundColor ?? buttonColor;
              }),
              backgroundColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.pressed)) {
                  return (backgroundColor ?? Theme.of(context).primaryColor)
                      .withValues(alpha: 0.5);
                } else if (states.contains(WidgetState.disabled)) {
                  return (backgroundColor ?? Theme.of(context).primaryColor)
                      .withValues(alpha: 0.5);
                } else {
                  return (backgroundColor ?? Theme.of(context).primaryColor);
                }
              }),
            ),
        onPressed: isBusy ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isBusy)
              Row(
                children: [
                  SizedBox(
                    width: getProgressRadiusByButtonSizeWidth(size),
                    height: getProgressRadiusByButtonSize(size),
                    child: kLoadingIndicator(
                      strockWidth: getProgressWidthByButtonSize(size),
                      context: context,
                    ),
                  ),
                  lWidthSpan,
                ],
              )
            else
              child,
          ],
        ),
      ),
    );
  }
}
