
class Job {
   Job({required this.id, required this.name, required this.ratePerHour});

  final String id;
  final String name;
  final num ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final num ratePerHour = data['ratePerHour'];
    return Job(id: documentId, name: name, ratePerHour: ratePerHour);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "ratePerHour": ratePerHour,
    };
  }
}
