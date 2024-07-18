import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/database.dart';
import '../../../widgets/platform_exception_alert_dialog.dart';
import '../job_entries/job_entries_page.dart';
import '../models/job.dart';
import 'edit_job_page.dart';
import 'job_list_tile.dart';
import 'list_items_builder.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dataBase = Provider.of<DataBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Jobs'),
        actions: [
          IconButton(
              onPressed: () => EditJobPage.show(
                  context: context,
                  dataBase: dataBase,
                  job: null,
                  title: 'New Job'),
              icon: const Icon(Icons.add)),
        ],
      ),
      body: _buildContent(context),
    );
  }
}

Future<void> _delete(BuildContext context, Job job) async {
  try {
    final dataBase = Provider.of<DataBase>(context, listen: false);
    await dataBase.deleteData(job);
  } on FirebaseException catch (e) {
    if (!context.mounted) return;

    PlatformExceptionAlertDialog(
      title: "An error occurred",
      firebaseException: e,
    ).show(context);
  }
}

Widget _buildContent(BuildContext context) {
  final dataBase = Provider.of<DataBase>(context, listen: false);

  return StreamBuilder<List<Job>>(
      stream: dataBase.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            background: Container(
              color: Colors.red,
            ),
            key: Key('job-dismissible-id:${job.id}'),
            child: JobListTile(
              tap: () => JobEntriesPage.show(context, job),
              job: job,
            ),
          ),
        );
      });
}
