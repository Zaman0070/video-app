import 'package:flutter/material.dart';

import '../../../constant/color.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(
    this.controller,
    this.autoFocus,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widgtColor,
        border: Border.all(color: appColor1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: appColor1,
        decoration: const InputDecoration(
            fillColor: widgtColor,
            filled: true,
            border: InputBorder.none,
            counterText: '',
            hintStyle: TextStyle(color: textColor, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
