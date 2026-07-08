import 'package:flutter/material.dart';

import '../common/constant/app_dimens.dart';

//Add your custom colors and fonts for the app in this file
const fontFamily = "Poppins";
const primaryColor = Color.fromARGB(255, 6, 47, 94);
const secondaryColor = Color(0xFF006C73);

//Other colors for app
const avatarBackgroundColor = Color.fromRGBO(91, 91, 91, 91);
const shadowColor = Color.fromRGBO(0, 0, 0, 0.04);
const scaffoldBgColor = Color(0xFFF5F5F7);

const disabledColor = Color(0xFFbcbcbc);
const disabledSoftColor = Color(0x4DFFFFFF);
const darkSucessColor = Color.fromARGB(255, 22, 101, 52);
const darkErrorColor = Color(0xFFC11414);
const cardColor = Color(0xFF2d3032);
const shutleGrey = Color(0xFFf4f4f4);
const errorColor = Color(0xFFEF4444);
const successColor = Color(0xFF00da9f);
const warningColor = Color(0xFFfce8bb);
const warningIconColor = Color(0xFFf3b31c);
const darkGrey = Color(0xFF5b5b5b);
const lightGrey = Color(0xFFf3f6f9);
const chipGrey = Color(0xFFe1e1e1);
const cursorColor = Color(0xFF666666);
const bodyColor = Color(0xFF000000);
const buttonColor = Color(0xFFFFFFFF);
const inputSuffixIconClor = Color(0xFF6dd819);
const containerColor = Color.fromARGB(255, 234, 238, 243);
const lightThemeContainerColor = Color(0xFFF6F6F6);

Color getColor(Set<WidgetState> states) {
  const Set<WidgetState> interactiveStates = <WidgetState>{
    WidgetState.pressed,
    WidgetState.hovered,
    WidgetState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.blue;
  }
  return primaryColor;
}

abstract class AppThemes {
  //light theme
  static ThemeData light = ThemeData.light().copyWith(
    scaffoldBackgroundColor: scaffoldBgColor,
    primaryColor: primaryColor,
    cardColor: const Color.fromRGBO(240, 240, 240, 1.0),
    drawerTheme: const DrawerThemeData(backgroundColor: scaffoldBgColor),
    textSelectionTheme: ThemeData.light().textSelectionTheme.copyWith(
      cursorColor: cursorColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: scaffoldBgColor,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(getColor),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      titleTextStyle: ThemeData.light().textTheme.bodyMedium?.copyWith(
        fontSize: AppDimens.headlineFontSizeSmall1,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: ThemeData.light().textTheme
        .apply(bodyColor: Colors.black, fontFamily: fontFamily)
        .copyWith(
          bodyMedium: ThemeData.light().textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontSize: AppDimens.headlineFontSizeXXSmall,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
