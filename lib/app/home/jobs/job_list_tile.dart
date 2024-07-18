import 'package:flutter/material.dart';

import '../models/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({
    Key? key,
    required this.job,
    required this.tap,
  }) : super(key: key);
  final Job job;
  final VoidCallback tap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        job.name,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => tap(),
    );
  }
}
