import 'package:flutter/material.dart';

import '../../widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    super.key,
    required String? text,
    Color? color,
    double? radius,
    Color? textColor,
    VoidCallback? onPressed,
  }) : super(
          onPressed: onPressed,
          backgroundColor: color ?? Colors.white,
          radius: radius ?? 6.0,
          child: Text(
            text ?? "",
            style: TextStyle(
              color: textColor ?? Colors.black87,
              fontSize: 15,
            ),
          ),
        );
}
