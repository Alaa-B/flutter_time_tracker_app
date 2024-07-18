import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/database.dart';
import '../../../widgets/platform_exception_alert_dialog.dart';
import '../jobs/edit_job_page.dart';
import '../jobs/list_items_builder.dart';
import '../models/entry.dart';
import '../models/job.dart';
import 'entry_list_item.dart';
import 'entry_page.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({super.key, required this.database, required this.job});

  final DataBase database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<DataBase>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      if (!context.mounted) return;

      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        firebaseException: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(job.id),
        builder: (context, snapshot) {
          final job = snapshot.data;
          final jobName = job?.name;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 2.0,
              title: Text(jobName ?? ""),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () => EditJobPage.show(
                      context: context,
                      dataBase: database,
                      job: snapshot.data,
                      title: 'Edit Job'),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
                  onPressed: () => EntryPage.show(
                    context: context,
                    database: database,
                    job: job ?? this.job,
                    entry: null,
                  ),
                ),
              ],
            ),
            body: _buildContent(context, job),
          );
        });
  }

  Widget _buildContent(BuildContext context, Job? job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job ?? this.job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job ?? this.job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job ?? this.job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
