import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class ApplicationHeatMap extends StatelessWidget {
  final DateTime startDate;

  final Map<DateTime, int> datasets;

  const ApplicationHeatMap(
      {super.key, required this.startDate, required this.datasets});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.inversePrimary,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets: const {
        1: Color.fromARGB(255, 76, 175, 80),
        2: Color.fromARGB(255, 76, 185, 90),
        3: Color.fromARGB(255, 76, 195, 100),
        4: Color.fromARGB(255, 76, 205, 110),
        5: Color.fromARGB(255, 76, 215, 120)
      },
    );
  }
}
