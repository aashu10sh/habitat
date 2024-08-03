// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:habitat/components/application_drawer.dart';
import 'package:habitat/components/application_heat_map.dart';
import 'package:habitat/components/application_tile.dart';
import 'package:habitat/database/habit_database.dart';
import 'package:habitat/models/habit.dart';
import 'package:habitat/utils/habit.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  final TextEditingController textController = TextEditingController();

  Future<void> createNewHabit() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Create a new Habit"),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              textController.clear();
              Navigator.pop(context);
            },
            child: Text("Close"),
          ),
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;
              context.read<HabitDatabase>().addHabit(newHabitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void toggleHabit(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  textController.clear();
                  Navigator.pop(context);
                },
                child: Text("Close"),
              ),
              MaterialButton(
                onPressed: () {
                  String toUpdateName = textController.text;
                  context
                      .read<HabitDatabase>()
                      .updateHabitName(habit.id, toUpdateName);
                  Navigator.pop(context);
                  textController.clear();
                },
                child: Text("Edit"),
              ),
            ],
          );
        });
  }

  void deleteHabitBox(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text("Are You Sure?"),
            actions: [
              MaterialButton(
                onPressed: () {
                  textController.clear();
                  Navigator.pop(context);
                },
                child: Text("Close"),
              ),
              MaterialButton(
                onPressed: () {
                  context.read<HabitDatabase>().deleteHabit(id);
                  Navigator.pop(context);
                  textController.clear();
                },
                child: Text("Delete"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Habitat"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const ApplicationDrawer(),
      body: ListView(children: [
        _buildHeatMap(),
        _buildHabitList(),
      ]),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: createNewHabit,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
        itemCount: currentHabits.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final habit = currentHabits[index];

          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

          return ApplicationTile(
            isCompleted: isCompletedToday,
            text: habit.name,
            onChanged: (value) {
              toggleHabit(value, habit);
            },
            editHabit: (context) => editHabitBox(habit),
            deleteHabit: (context) => deleteHabitBox(habit.id),
          );
        });
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ApplicationHeatMap(
            startDate: snapshot.data!,
            datasets: prepateHeatMapDataSet(currentHabits),
          );
        } else {
          return Container(
            child: Text(
              "Nothing to Show!",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          );
        }
        // throw Exception("");
      },
    );
  }
}
