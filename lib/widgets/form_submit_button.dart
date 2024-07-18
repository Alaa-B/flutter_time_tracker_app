import 'package:flutter/material.dart';

import 'custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    super.key,
    required String text,
    required VoidCallback? onPressed,
  }) : super(
          child: Text(
            text,
            style:const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.indigo,
          radius: 4,
          onPressed: onPressed,
        );
}
