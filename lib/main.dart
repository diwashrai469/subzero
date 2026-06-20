import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/core/services/firebase/fcm_service.dart';
import 'common/constant/app_dimens.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  setupLocator();

  await FCMService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _permissionDialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermission();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    if (!mounted || _permissionDialogShowing) return;

    final allowed = await FCMService.hasNotificationPermission();

    if (allowed) return;

    _permissionDialogShowing = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Turn on notifications'),
          content: const Text(
            'SubZero needs notifications to remind you before your subscriptions are due.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                locator<AppRouters>().popForced();
              },
              child: const Text('Not now'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FCMService.requestPermission();

                if (context.mounted) {
                  locator<AppRouters>().popForced();
                }
              },
              child: const Text('Turn on'),
            ),
          ],
        );
      },
    );

    _permissionDialogShowing = false;
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: ScreenUtilInit(
        designSize: const Size(AppDimens.appWidth, AppDimens.appHeight),
        builder: (_, _) {
          return MaterialApp.router(
            theme: AppThemes.light,
            routerConfig: locator<AppRouters>().config(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
