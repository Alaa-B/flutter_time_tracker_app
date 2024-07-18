import 'package:flutter/material.dart';

class EmptyJobPage extends StatelessWidget {
  const EmptyJobPage({
    Key? key,
    this.tittle = 'Nothing Here',
    this.message = 'Add New Job And Get Started',
  }) : super(key: key);

  final String tittle;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tittle, 
            style: const TextStyle(fontSize: 28, color: Colors.black38),
          ),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.black38),
          )
        ],
      ),
    );
  }
}
