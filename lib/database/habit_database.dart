import 'package:flutter/material.dart';
import 'package:habitat/models/app_settings.dart';
import 'package:habitat/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  final List<Habit> currentHabits = [];

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  Future<void> addHabit(String habitName) async {
    var habit = Habit()..name = habitName;
    await isar.writeTxn(() => isar.habits.put(habit));
    await readHabits();
  }

  Future<void> readHabits() async {
    List<Habit> habits = await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(habits);
    notifyListeners();
  }

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final Habit? habit = await isar.habits.get(id);

    if (habit != null) {
      isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          habit.completedDays.add(DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ));
        } else {
          habit.completedDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day);
        }
        await isar.habits.put(habit);
      });
    }
    await readHabits();
  }

  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    await readHabits();
  }

  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async => await isar.habits.delete(id));
    await readHabits();
  }
}
