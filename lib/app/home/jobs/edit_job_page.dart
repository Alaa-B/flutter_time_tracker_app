import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/widgets/platform_alert_dialog.dart';

import '../../../services/database.dart';
import '../../../widgets/platform_exception_alert_dialog.dart';
import '../models/job.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({
    Key? key,
    required this.dataBase,
    required this.job,
    required this.title,
  }) : super(key: key);
  final DataBase dataBase;
  final Job? job;
  final String title;

  static Future<void> show(
      {required BuildContext context,
      required DataBase dataBase,
      Job? job,
      required String title}) async {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            EditJobPage(dataBase: dataBase, job: job, title: title),
      ),
    );
  }

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  DataBase get dataBase => widget.dataBase;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? jobName;

  num? ratePerHour;

  bool _isLoading = false;
  final _jobFocusNode = FocusNode();
  final _rateFocusNode = FocusNode();

  @override
  void initState() {
    if (widget.job != null) {
      jobName = widget.job?.name;
      ratePerHour = widget.job?.ratePerHour;
    }
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form?.validate() == null || form?.validate() == false) {
      return false;
    }
    form!.save();
    return true;
  }

  Future<void> _submit(BuildContext context, VoidCallback pop,
      VoidCallback showAlertDialog) async {
    if (_validateAndSaveForm()) {
      try {
        setState(() {
          _isLoading = true;
        });
        final jobs = await dataBase.jobsStream().first;
        final allJobsName = jobs.map((snapshot) => snapshot.name).toList();
        if (widget.job != null) allJobsName.remove(widget.job?.name);
        if (allJobsName.contains(jobName)) {
          showAlertDialog();
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentTime;
          final job = Job(name: jobName!, ratePerHour: ratePerHour!, id: id);
          await dataBase.setJob(job);
          pop();
        }
      } on FirebaseException catch (e) {
        if (!context.mounted) return;

        PlatformExceptionAlertDialog(
          title: 'Error',
          firebaseException: e,
        ).show(context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () => _isLoading
                ? null
                : _submit(context, () {
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  }, () {
                    const PlatformAlertDialog(
                      title: 'job already exist',
                      content: 'enter another job',
                      defaultActionText: 'OK',
                    ).show(context);
                  }),
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFormChildren(context),
      ),
    );
  }

  List<Widget> _buildFormChildren(BuildContext context) {
    return [
      TextFormField(
        enabled: _isLoading ? false : true,
        autofocus: true,
        focusNode: _jobFocusNode,
        decoration: const InputDecoration(labelText: 'job name'),
        initialValue: jobName,
        validator: (value) => (value != null && value.isNotEmpty)
            ? null
            : "job name Can't be empty",
        onSaved: (value) => jobName = value ?? "",
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(_rateFocusNode),
      ),
      TextFormField(
        enabled: _isLoading ? false : true,
        focusNode: _rateFocusNode,
        keyboardType: const TextInputType.numberWithOptions(
            decimal: false, signed: false),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: const InputDecoration(labelText: 'rate per hour'),
        initialValue: ratePerHour != null ? '$ratePerHour' : null,
        validator: (value) =>
            (value != null && value.isNotEmpty) ? null : "rate can't be empty",
        onSaved: (value) => ratePerHour = int.tryParse(value ?? '')!,
        onEditingComplete: () => _submit(context, () {
          if (!mounted) return;
          Navigator.of(context).pop();
        }, () {
          const PlatformAlertDialog(
            title: 'job already exist',
            content: 'enter another job',
            defaultActionText: 'OK',
          ).show(context);
        }),
      ),
    ];
  }
}
