import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app_v2/services/notification_services.dart';
import '../services/theme_services.dart';
import '../ui/theme.dart';

import 'ui/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotifyHelper.intialize();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      theme: Themes.light_theme,
      darkTheme: Themes.dark_theme,
      themeMode: ThemeServices().theme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
