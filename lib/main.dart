import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/routes/routes.dart';
import 'package:budget_app/views/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(Constants.appSettings);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(Constants.appSettings).listenable(),
      builder: (context, box, child) {
        var showStart = box.get(Constants.appShowStart, defaultValue: true);
        var hasPassword = box.get(Constants.appPassword, defaultValue: false);

        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
              primary: Color(0xff33b6e7),
            ),
          ),

          //* Routes of the application
          initialRoute: showStart
              ? StartPage.pageKey
              : hasPassword
                  ? PassLoginPage.pageKey
                  : HomePage.pageKey,
          routes: appRoutes,
        );
      },
    );
  }
}
