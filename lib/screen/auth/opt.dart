import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/constant/widget/app_button.dart';
import 'package:video_app/constant/widget/loading.dart';
import 'package:video_app/model/user_model.dart';
import 'package:video_app/screen/auth/widget/otp_input.dart';
import 'package:video_app/screen/bottom_nav/bottom_nav.dart';
import 'package:video_app/services/phone_services.dart';

class OTP extends StatefulWidget {
  final String? number;
  final String? verId;
  const OTP({super.key, this.number, this.verId});
  @override
  State<OTP> createState() => _LoginPageState();
}

class _LoginPageState extends State<OTP> {
  String error = '';
  late Timer _timer;
  int _start = 60;

  final PhoneService _phoneService = PhoneService();
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  Future<void> phoneCredential(BuildContext context, String otp) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      SmartDialog.showLoading(
        animationBuilder: (controller, child, animationParam) {
          return Loading(
            text: 'Loading...',
          );
        },
      );
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verId!, smsCode: otp);
      // need to oto validate or no

      final authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user!;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      print(user.uid);
      print(user.phoneNumber);
      final QuerySnapshot result = await users
          .where('phoneNumber',
              isEqualTo: user.phoneNumber!.replaceAll("+", ''))
          .get();
      List<DocumentSnapshot> document = result.docs;
      // ignore: unnecessary_null_comparison
      if (user != null) {
        if (document.isEmpty) {
          OSDeviceState? status = await OneSignal.shared.getDeviceState();
          UserModel userModel = UserModel(
            token: status!.userId,
            uid: user.uid,
            phoneNumber: user.phoneNumber,
            email: '',
            name: '',
          );
          _phoneService.users
              .doc(user.uid)
              .set(userModel.toMap())
              .then((value) {
            Get.offAll(() => const BottomBars());

            // ignore: invalid_return_type_for_catch_error
          }).catchError((error) =>
                  // ignore: invalid_return_type_for_catch_error
                  Fluttertoast.showToast(msg: 'Faild to add user : $error'));
          SmartDialog.dismiss();
        } else {
          Get.offAll(() => const BottomBars());
          SmartDialog.dismiss();
        }
      } else {
        print('login Failed');
        if (mounted) {
          setState(() {
            error = 'login failed';
          });
        }
      }
    } catch (e) {
      print(e.toString());
      if (mounted) {
        setState(() {
          error = 'Invalid OTP';
        });
      }
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'assets/background.png',
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 70.h,
                  ),
                  CircleAvatar(
                    radius: 50.h,
                    backgroundColor: appColor1,
                    child: const Text('Logo'),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OtpInput(_fieldOne, true),
                      ),
                      Expanded(
                        child: OtpInput(_fieldTwo, false),
                      ),
                      Expanded(
                        child: OtpInput(_fieldThree, false),
                      ),
                      Expanded(child: OtpInput(_fieldFour, false)),
                      Expanded(child: OtpInput(_fieldFive, false)),
                      Expanded(child: OtpInput(_fieldSix, false)),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_start sec',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: appColor1),
                      ),
                      const Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AppButton(
                    label: 'Continue',
                    onPressed: () {
                      if (_fieldOne.text.length == 1) {
                        if (_fieldTwo.text.length == 1) {
                          if (_fieldThree.text.length == 1) {
                            if (_fieldFour.text.length == 1) {
                              if (_fieldFive.text.length == 1) {
                                String _otp =
                                    '${_fieldOne.text}${_fieldTwo.text}'
                                    '${_fieldThree.text}${_fieldFour.text}'
                                    '${_fieldFive.text}${_fieldSix.text}';

                                setState(() {
                                  phoneCredential(context, _otp);
                                });

                                // login
                              }
                            }
                          }
                        }
                      } else {}
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _start = 60;
                        startTimer();
                      });
                      _phoneService.verificationPhoneNumber(
                          context, widget.number);
                    },
                    child: Container(
                      height: 45.h,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: appColor1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: appColor1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            content: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('تم تأكيد الدخول'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'وسيط ',
                        style: TextStyle(color: appColor1),
                      ),
                      const Text('مرحباً بك في تطبيق'),
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }
}
