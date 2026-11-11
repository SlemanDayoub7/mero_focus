import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/theme/app_colors.dart';
import 'core/constants/app_constants.dart';
import 'features/home/presentation/pages/placeholder_home_page.dart';

class MeroFocusApp extends StatelessWidget {
  const MeroFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(colorScheme: AppColors.light, useMaterial3: true),
      darkTheme: ThemeData(colorScheme: AppColors.dark, useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const PlaceholderHomePage(),
    );
  }
}
