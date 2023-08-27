import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/constant/color.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Icon icon;
  final bool obsecure;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    required this.obsecure,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ' $label',
          style: const TextStyle(color: Colors.white54, fontSize: 18),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(12),
              color: widgtColor),
          height: 50.0,
          child: TextFormField(
            validator: validator,
            controller: controller,
            obscureText: obsecure,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 14.0),
                prefixIcon: icon,
                hintText: label,
                hintStyle: const TextStyle(
                  color: Colors.white54,
                  fontFamily: 'OpenSans',
                )),
          ),
        ),
      ],
    );
  }
}

class InputField1 extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obsecure;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;


  const InputField1({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    required this.obsecure,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ' $label',
          style: const TextStyle(color: Colors.white54, fontSize: 18),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(12),
              color: widgtColor),
          height: 50.0,
          child: TextFormField(
            keyboardType: keyboardType,
            validator: validator,
            controller: controller,
            obscureText: obsecure,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 0.0, left: 10),
                hintText: label,
                hintStyle: const TextStyle(
                  color: Colors.white54,
                  fontFamily: 'OpenSans',
                )),
          ),
        ),
      ],
    );
  }
}
