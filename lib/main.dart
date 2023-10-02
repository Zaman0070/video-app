import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/language/local_string.dart';
import 'package:video_app/screen/navigation/navigation.dart';
import 'package:video_app/services/share_pref.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:aba_payment/aba_payment.dart';
import 'package:aba_payment/services/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env_sample");
  PaywayTransactionService.ensureInitialized(ABAMerchant(
    merchantID: dotenv.get('ABA_PAYWAY_MERCHANT_ID'),
    merchantApiName: dotenv.get('ABA_PAYWAY_MERCHANT_NAME'),
    merchantApiKey: dotenv.get('ABA_PAYWAY_API_KEY'),
    baseApiUrl: dotenv.get('ABA_PAYWAY_API_URL'),
    refererDomain:
        "https://play.google.com/store/apps/details?id=com.theAppForce.videoapp",
  ));

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId('66400e53-7ca4-44b9-84bf-7146415c8076');
  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    event.complete(event.notification);
  });
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
            translations: LocalString(),
            locale: const Locale('en', 'US'),
            navigatorObservers: [FlutterSmartDialog.observer],
            builder: FlutterSmartDialog.init(),
            debugShowCheckedModeBanner: false,
            title: 'Meas Meta',
            theme: ThemeData(
              scaffoldBackgroundColor: background,
              primarySwatch: primaryswatch,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: child,
          );
        },
        child: const Navigations());
  }
}
