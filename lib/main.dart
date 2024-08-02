import 'package:flutter/material.dart';
import 'package:habitat/database/habit_database.dart';
import 'package:habitat/pages/home_page.dart';
import 'package:habitat/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => HabitDatabase()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MainApplication(),
  ));
}

class MainApplication extends StatelessWidget {
  const MainApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SafeArea(
        child: HomePage(),
      ),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
