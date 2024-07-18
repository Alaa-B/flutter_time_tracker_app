import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  const PlatformAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelActionText,
    required this.defaultActionText,
  });

  final String title;
  final String? content;
  final String? cancelActionText;
  final String defaultActionText;

  Future<bool?> show(BuildContext context) async {
    if (Platform.isIOS) {
      return await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => this,
      );
    } else {
      return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => this,
      );
    }
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content??"Error Happened"),
      actions: _buildAction(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content??"Error Happened"),
      actions: _buildAction(context),
    );
  }

  List<Widget> _buildAction(BuildContext context) {
    return [
      if (cancelActionText != null)
        PlatformAlertDialogAction(
          child: Text(cancelActionText!),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      PlatformAlertDialogAction(
        child: Text(defaultActionText),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    ];
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  const PlatformAlertDialogAction({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      child: child,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
