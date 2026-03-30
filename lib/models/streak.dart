import 'package:hive/hive.dart';

part 'streak.g.dart';

@HiveType(typeId: 2)
class StreakModel extends HiveObject {
  @HiveField(0)
  final int currentStreak;

  @HiveField(1)
  final DateTime lastActiveDate;

  StreakModel({
    required this.currentStreak,
    required this.lastActiveDate,
  });
}
