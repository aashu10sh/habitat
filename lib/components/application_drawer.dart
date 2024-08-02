import 'package:flutter/material.dart';
import 'package:habitat/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ApplicationDrawer extends StatelessWidget {
  const ApplicationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Switch(
          value: Provider.of<ThemeProvider>(context).isDarkMode,
          onChanged: (value) =>
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme()),
    );
  }
}
