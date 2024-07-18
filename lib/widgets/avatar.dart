import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.photoURL,
    required this.radius,
  });

  final String? photoURL;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.black12,
      backgroundImage: photoURL != null ? NetworkImage(photoURL!) : null,
      child: photoURL == null
          ? const IconButton(onPressed: null, icon: Icon(Icons.camera_alt))
          : null,
    );
  }
}
