import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_app/constant/color.dart';
import 'package:video_app/constant/widget/app_button.dart';
import 'package:video_app/screen/auth/widget/text_field.dart';
import 'package:video_app/services/auth_services.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  var passwordTextController = TextEditingController();
  var emailTextController = TextEditingController();
  Authentication authentication = Authentication();
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
              CircleAvatar(
                radius: 50.h,
                backgroundColor: appColor1,
                child: const Text('Logo'),
              ),
              SizedBox(
                height: 25.h,
              ),
              Text(
                'Admin Sign With Email and Password',
                style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white54),
              ),
              SizedBox(
                height: 50.h,
              ),
              InputField(
                obsecure: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required Email';
                  }
                  return null;
                },
                icon: const Icon(
                  Icons.email,
                  color: Colors.grey,
                ),
                controller: emailTextController,
                label: 'Email',
              ),
              SizedBox(
                height: 10.h,
              ),
              InputField(
                obsecure: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required Password';
                  }
                  return null;
                },
                icon: const Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                controller: passwordTextController,
                label: 'Password',
              ),
              SizedBox(
                height: 12.h,
              ),
              AppButton(
                label: 'Admin Sign In',
                onPressed: () async {
                  if (emailTextController.text.trim().isNotEmpty &&
                      passwordTextController.text.trim().isNotEmpty) {
                    emailTextController.text == 'Measacademy@gmail.com' ||
                            emailTextController.text == 'measacademy@gmail.com'
                        ? authentication.adminLogin(
                            emailTextController.text,
                            passwordTextController.text,
                            context,
                          )
                        : Fluttertoast.showToast(msg: 'Invalid Email');
                  } else {
                    Fluttertoast.showToast(msg: 'Required Email and password');
                  }
                },
              ),
              SizedBox(
                height: 4.h,
              ),
            ],
          ),
        ),
      ),
    )));
  }
}
