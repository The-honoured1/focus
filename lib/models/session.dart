import 'package:hive/hive.dart';

part 'session.g.dart';

@HiveType(typeId: 0)
enum SessionStatus {
  @HiveField(0)
  success,
  @HiveField(1)
  fail
}

@HiveType(typeId: 1)
class SessionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime startTime;

  @HiveField(2)
  final DateTime endTime;

  @HiveField(3)
  final int durationSeconds;

  @HiveField(4)
  final SessionStatus status;

  @HiveField(5)
  final String outputText;

  SessionModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationSeconds,
    required this.status,
    required this.outputText,
  });
}
