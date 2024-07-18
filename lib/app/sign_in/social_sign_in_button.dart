import 'package:flutter/material.dart';
import '../../widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    super.key,
    required String assetText,
    required String text,
    required Color textColor,
    required VoidCallback? onPressed,
    Color? color,
    double? radius,
  }) : super(
          onPressed: onPressed,
          backgroundColor: color ?? Colors.white70,
          radius: radius ?? 2.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetText),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
              Opacity(opacity: 0, child: Image.asset(assetText)),
            ],
          ),
        );
}
