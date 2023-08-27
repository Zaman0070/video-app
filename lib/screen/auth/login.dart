import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:video_app/admin/auth/admin_login.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/constant/widget/app_button.dart';
import 'package:video_app/screen/auth/widget/text_field.dart';
import 'package:video_app/services/auth_services.dart';
import 'package:video_app/services/phone_services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var phoneTextController = TextEditingController();
  Authentication authentication = Authentication();
  PhoneService service = PhoneService();
  CountryCode countryCode = CountryCode(code: 'KH', dialCode: '+855');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
            body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50.h,
              ),
              InkWell(
                overlayColor: MaterialStateProperty.all(background),
                onLongPress: () {
                  Get.to(() => const AdminLogin());
                },
                child: CircleAvatar(
                  radius: 50.h,
                  backgroundColor: appColor1,
                  child: const Text('Logo'),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              SizedBox(
                height: 25.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        height: 43.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: border),
                            borderRadius: BorderRadius.circular(12),
                            color: widgtColor),
                        child: CountryCodePicker(
                          padding: EdgeInsets.zero,
                          flagWidth: 15,
                          barrierColor: Colors.black.withOpacity(0.5),
                          onChanged: (CountryCode code) {
                            setState(() {
                              countryCode = code;
                              print(countryCode);
                            });
                          },
                          dialogBackgroundColor: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.5),
                          initialSelection: 'KH',
                          favorite: ['+855', 'KH'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    flex: 2,
                    child: InputField1(
                      keyboardType: TextInputType.number,
                      obsecure: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required Email';
                        }
                        return null;
                      },
                      controller: phoneTextController,
                      label: 'Phone Number',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 1.h,
              ),
              AppButton(
                label: 'Login',
                onPressed: () async {
                  if (phoneTextController.text.trim().isNotEmpty) {
                    String phone = countryCode.toString() +
                        phoneTextController.text.trim();
                    print(phone);
                    await service.verificationPhoneNumber(context, phone);
                  } else {
                    Fluttertoast.showToast(msg: 'Please Enter Phone Number');
                  }
                },
              ),
              SizedBox(
                height: 45.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 1,
                      width: 50,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const Text(
                    'Or',
                    style: TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 1,
                      width: 50,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 55.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Platform.isIOS
                            ? await authentication.signInWithApple()
                            : await authentication.loginWithFacebook();
                      },
                      child: Container(
                        height: 40.h,
                        width: 180,
                        decoration: BoxDecoration(
                            color: widgtColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: border)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Platform.isIOS ? Icons.apple : Icons.facebook,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 7.w,
                            ),
                            Text(
                              Platform.isIOS ? 'Apple' : 'Facebook',
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Platform.isAndroid
                            ? await authentication.signInWithGoogle(
                                context: context)
                            : await authentication.loginWithFacebook();
                      },
                      child: Container(
                        height: 45.h,
                        decoration: BoxDecoration(
                            color: widgtColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: border)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Platform.isAndroid
                                  ? Icons.g_mobiledata_outlined
                                  : Icons.facebook_sharp,
                              color: Colors.white,
                              size: 35,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              'Google',
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    )));
  }
}
