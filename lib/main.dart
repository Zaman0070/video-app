import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/screen/bottom_nav/bottom_nav.dart';
import 'package:video_app/screen/navigation/navigation.dart';
import 'package:video_app/services/share_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId('66400e53-7ca4-44b9-84bf-7146415c8076');
  SharePref sharePref = SharePref();
  String? type = await sharePref.getType('login');
  runApp(MyApp(
    type: type!,
  ));
}

class MyApp extends StatelessWidget {
  final String type;
  const MyApp({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            navigatorObservers: [FlutterSmartDialog.observer],
            builder: FlutterSmartDialog.init(),
            debugShowCheckedModeBanner: false,
            title: 'First Method',
            theme: ThemeData(
              scaffoldBackgroundColor: background,
              primarySwatch: primaryswatch,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: child,
          );
        },
        child: type == 'user' ? const BottomBars() : const Navigations());
  }
}
