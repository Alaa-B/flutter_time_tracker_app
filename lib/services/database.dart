import '/app/home/models/job.dart';
import '/services/api_path.dart';

import '../app/home/models/entry.dart';
import 'firestore_service.dart';

abstract class DataBase {
  Future<void> setJob(Job jobData);

  Future<void> deleteData(Job job);

  Future<void> setEntry(Entry entry);

  Future<void> deleteEntry(Entry entry);

  Stream<List<Entry>> entriesStream(Job? job);

  Stream<List<Job>> jobsStream();
  Stream<Job> jobStream(String jobId);
}

String get documentIdFromCurrentTime => DateTime.now().toIso8601String();

class FireStoreDataBase implements DataBase {
  FireStoreDataBase({required this.uid});

  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async {
    await _service.setData(
      path: APIPath.job(uid, job.id),
      data: job.toMap(),
    );
  }

  @override
  Future<void> deleteData(Job job) async {
    final allEntries = await entriesStream(job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    String path = APIPath.job(uid, job.id);
    await _service.deleteData(path: path);
  }

  @override
  Stream<List<Job>> jobsStream() {
    String path = APIPath.jobs(uid);
    return _service.collectionStream(
      path: path,
      builder: (data, documentId) => Job.fromMap(data, documentId),
    );
  }

  @override
  Stream<Job> jobStream(String jobId) {
    return _service.documentStream(
        path: APIPath.job(uid, jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId));
  }

  @override
  Future<void> setEntry(Entry entry) async {
    await _service.setData(
      path: APIPath.entry(uid, entry.id),
      data: entry.toMap(),
    );
  }

  @override
  Future<void> deleteEntry(Entry entry) async {
    await _service.deleteData(path: APIPath.entry(uid, entry.id));
  }

  @override
  Stream<List<Entry>> entriesStream(Job? job) {
    return _service.collectionStream(
      path: APIPath.entries(uid),
      queryBuilder: job != null
          ? (query) => query.where('jobId', isEqualTo: job.id)
          : null,
      builder: (data, documentID) {
        return Entry.fromMap(data, documentID);
      },
      sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
    );
  }
}
