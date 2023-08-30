import 'dart:io' as io;
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/settings_notifier.dart';
import 'package:budget_app/views/home_page.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class StartPage extends ConsumerWidget {
  const StartPage({super.key});

  static const String pageKey = '/start';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomButton customButton = CustomButton();
    var language = ref.watch(notiProvLanguages);
    var indexValue = 0;

    var start = language[indexValue]![Constants.startText]!;

    return Scaffold(
      body: Center(
        child: customButton.showButton(
          context: context,
          text: start,
          onPress: () async {
            //* Once user clicks the button, stores that the user saw the
            //* start page on the phone and navigates to the home page

            // //* stores user default preferences
            var box = Hive.box(Constants.appSettings);
            box.put(Constants.appShowStart, false);
            box.put(Constants.appPassword, false);
            box.put(Constants.appReminder, false);
            box.put(Constants.appLanguage, 0);
            box.put(Constants.hasNewBudgetBeenCreated, false);

            //* creates initial budget on first start up
            var year = DateFormat('yyyy').format(DateTime.now());
            var month = DateTime.now().month - 1;

            String fileName = "$year$month.txt";
            String dataToWrite =
                "$year ${Constants.keySeparator} $month ${Constants.keySeparator} $fileName \n";

            final io.Directory directory =
                await getApplicationDocumentsDirectory();
            final String fullPath =
                '${directory.path}/${Constants.fileBudgetManager}';
            final io.File file = io.File(fullPath);

            await file.writeAsString(dataToWrite);

            if (context.mounted) {
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => const HomePage()),
                ModalRoute.withName(HomePage.pageKey),
              );
            }
          },
        ),
      ),
    );
  }
}
