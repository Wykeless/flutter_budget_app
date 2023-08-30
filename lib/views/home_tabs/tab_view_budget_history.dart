import 'dart:developer';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/budget_notifier.dart';
import 'package:budget_app/data/settings_notifier.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/views/screens.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewBudgetTab extends ConsumerWidget {
  const ViewBudgetTab({
    super.key,
    required this.budgetData,
  });

  final AsyncValue<List<Budget>> budgetData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return budgetData.when(
      data: (budgetData) {
        return BudgetList(budgetData: budgetData);
      },
      loading: () => const SizedBox(
        height: 150,
        width: 150,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Text(
        error.toString(),
      ),
    );
  }
}

class BudgetList extends ConsumerStatefulWidget {
  const BudgetList({
    super.key,
    required this.budgetData,
  });

  final List<Budget> budgetData;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BudgetListState();
}

class _BudgetListState extends ConsumerState<BudgetList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomButton customButton = CustomButton();
    CustomSnackbar customSnackbar = CustomSnackbar();

    //* Gets the devices screen width and returns it
    final deviceWidth = MediaQuery.of(context).size.width;
    TextStyle textStyle = TextStyle(fontSize: deviceWidth * 0.040);

    var languages = ref.watch(notiProvLanguages);
    var months = ref.watch(notiProvMonths);
    var index = ref.watch(notiProvLanguageIndex);
    var indexValue = 0;

    var isBudgetCreated = ref.watch(notiProvIsNextBudgetCreated);
    var isNextBudgetCreatedValue = false;
    var isAfter28th = DateTime.now().day >= 28;

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

    //* IndexValue determines what language to show to the user
    var createBudget = languages[indexValue]![Constants.nextBudgetText]!;
    var createdBudget = languages[indexValue]![Constants.createdBudgetText]!;

    isBudgetCreated.when(
      data: (data) {
        isNextBudgetCreatedValue = data;
      },
      loading: () {
        log('Loading');
      },
      error: (error, stackTrace) {
        log('Error: $error');
      },
    );

    var showButton = isAfter28th && isNextBudgetCreatedValue == false;

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: ListView.separated(
            itemCount: widget.budgetData.length,
            itemBuilder: (context, index) {
              String budgetMonth = months[indexValue]![
                  int.parse(widget.budgetData[index].month)]!;
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 12),
                  child: Text(
                    "$budgetMonth ${widget.budgetData[index].year}",
                    style: textStyle,
                  ),
                ),
                onTap: () async {
                  Navigator.of(context).pushNamed(
                    ViewBudgetPage.pageKey,
                    arguments: [
                      index,
                      widget.budgetData[index].year,
                      budgetMonth,
                      widget.budgetData[index].budgetName,
                      widget.budgetData.length
                    ],
                  );
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.black,
                height: 25,
                thickness: 0.5,
              );
            },
          ),
        ),
        Expanded(
          flex: 0,
          child: Visibility(
            visible: showButton,
            child: customButton.showButton(
              width: double.infinity,
              context: context,
              text: createBudget,
              onPress: () async {
                DateTime currentDate = DateTime.now();
                var nextMonth = currentDate.add(const Duration(days: 30));
                var year = currentDate.add(Duration.zero);
                if (currentDate.month == 12) {
                  year = currentDate.add(const Duration(days: 365));
                }

                await ref
                    .read(notiProvIsNextBudgetCreated.notifier)
                    .setIsCreatedValue(true);

                await ref.read(asyncBudgetProvider.notifier).saveBudget(
                      month: "${nextMonth.month - 1}",
                      year: "${year.year}",
                    );

                if (context.mounted) {
                  customSnackbar.showSnackBar(context, createdBudget, 1000);
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
