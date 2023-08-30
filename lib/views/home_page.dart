import 'dart:developer';
import 'package:budget_app/views/screens.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/budget_notifier.dart';
import 'package:budget_app/data/settings_notifier.dart';
import 'package:budget_app/data/transaction_notifier.dart';
import 'package:budget_app/views/home_tabs/home_tabs.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const String pageKey = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomAppBar customAppBar = CustomAppBar();
    NotificationManager notiManager = NotificationManager();

    //* Gets the devices screen width and returns it
    var deviceWidth = MediaQuery.of(context).size.width;
    TextStyle mainTextStyle = TextStyle(
      fontSize: deviceWidth * 0.06,
      fontWeight: FontWeight.bold,
    );
    TextStyle unselectedTextStyle = TextStyle(fontSize: deviceWidth * 0.040);
    TextStyle selectedTextStyle = TextStyle(
      fontSize: deviceWidth * 0.045,
      shadows: const [
        Shadow(
          color: Colors.white,
          blurRadius: 1,
        ),
      ],
    );

    final budgetManagerData = ref.watch(asyncBudgetProvider);
    final budgetIndex = ref.watch(indexValueProvider);
    final transactionData = ref.watch(asyncTransactionProvider(budgetIndex));
    final budgetData = ref.watch(asyncBudgetProvider);

    var languages = ref.watch(notiProvLanguages);
    var months = ref.watch(notiProvMonths);
    var index = ref.watch(notiProvLanguageIndex);
    var indexValue = 0;

    var budgetYear = '';
    var budgetMonth = '';
    var budgetName = '';
    var currentFileName = '';
    var length = 0;

    var isBudgetCreated = ref.watch(notiProvIsNextBudgetCreated);

    var isBefore28th = DateTime.now().day < 28;

    var rescheduleReminder = ref.watch(notiProvReminderSetting);

    index.when(
      data: (data) {
        indexValue = data;
      },
      loading: () {
        log('Loading');
      },
      error: (error, stackTrace) {
        log('Error: $error');
      },
    );

    //* IndexValue determines what language to show to the user.
    var home = languages[indexValue]![Constants.homeText]!;
    var transaction = languages[indexValue]![Constants.transactionText]!;
    var file = languages[indexValue]![Constants.fileText]!;
    var monthlyReminderText =
        languages[indexValue]![Constants.monthlyReminderText]!;
    var createBudgetReminderText =
        languages[indexValue]![Constants.createBudgetReminderText]!;

    //* Check whether user turned on notification and reschedules it
    rescheduleReminder.when(
      data: (data) {
        if (data) {
          Future.delayed(Duration.zero, () async {
            await notiManager.cancelScheduledNotification();
            await notiManager.scheduleReminderNotification(
              title: monthlyReminderText,
              body: createBudgetReminderText,
            );
          });
        }
      },
      loading: () {
        log('Loading');
      },
      error: (error, stackTrace) {
        log('Error: $error');
      },
    );

    //* Uses the data once read and assigns it to the variables.
    budgetManagerData.when(
      data: (data) {
        if (data.isNotEmpty) {
          budgetYear = data[budgetIndex].year;
          budgetMonth =
              months[indexValue]![int.parse(data[budgetIndex].month)]!;
          budgetName = "$budgetMonth $budgetYear";
          currentFileName = data[budgetIndex].budgetName;
          length = data.length;
        }
      },
      loading: () => const SizedBox(
        height: 150,
        width: 150,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Text(error.toString()),
    );

    //* user logs in before the 28th, change value to create budget for next month to false.
    isBudgetCreated.when(
      data: (isBudgetCreatedData) {
        if (isBefore28th) {
          Future.delayed(Duration.zero, () async {
            await ref
                .read(notiProvIsNextBudgetCreated.notifier)
                .setIsCreatedValue(false);
          });
        }
      },
      loading: () {
        log('Loading');
      },
      error: (error, stackTrace) {
        log('Error: $error');
      },
    );

    //* A Tab widget
    Widget tab(String text, double width) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 0),
        padding: const EdgeInsets.symmetric(vertical: 0),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.white,
              width: width,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: Tab(
          text: text,
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar.showAppBar(
        title: Text(
          budgetName,
          style: mainTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
              size: deviceWidth * 0.08,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsPage.pageKey);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left_sharp,
                    size: deviceWidth * 0.12,
                  ),
                  onPressed: () {
                    if (budgetIndex != 0) {
                      ref.read(indexValueProvider.notifier).state -= 1;
                    }
                  },
                ),
                SizedBox(
                  width: deviceWidth * 0.10,
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right_sharp,
                    size: deviceWidth * 0.12,
                  ),
                  onPressed: () {
                    if (budgetIndex != length - 1) {
                      ref.read(indexValueProvider.notifier).state++;
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 8,
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xff474747),
                  flexibleSpace: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TabBar(
                        indicator: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0),
                            ),
                            side: BorderSide(
                              width: 2,
                              color: Color(0xff33b6e7),
                            ),
                          ),
                          color: Color(0xff333333),
                        ),
                        indicatorPadding: const EdgeInsets.only(bottom: 2.5),
                        indicatorWeight: 8,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelPadding: const EdgeInsets.all(0),
                        labelColor: Colors.white,
                        labelStyle: selectedTextStyle,
                        unselectedLabelColor: Colors.grey,
                        unselectedLabelStyle: unselectedTextStyle,
                        splashFactory: NoSplash.splashFactory,
                        tabs: [
                          tab(home, 0),
                          tab(transaction, 0),
                          Tab(text: file)
                        ],
                      ),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TabBarView(
                    children: [
                      HomeTab(
                          transactionData: transactionData,
                          currentFileName: currentFileName,
                          index: budgetIndex),
                      TransactionTab(
                        transactionData: transactionData,
                        currentFileName: currentFileName,
                        budgetIndex: budgetIndex,
                      ),
                      ViewBudgetTab(
                        budgetData: budgetData,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
