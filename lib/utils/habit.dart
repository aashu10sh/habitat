import 'package:habitat/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completionDays) {
  final today = DateTime.now();

  return completionDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

Map<DateTime, int> prepateHeatMapDataSet(List<Habit> habits) {
  Map<DateTime, int> dataset = {};
  for (var habit in habits) {
    for (var date in habit.completedDays) {
      final normalizedDate = DateTime(date.year, date.month, date.day);

      if (dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
        continue;
      }
      dataset[normalizedDate] = 1;
    }
  }

  return dataset;
}
