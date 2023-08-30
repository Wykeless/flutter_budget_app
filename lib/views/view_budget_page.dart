import 'dart:developer';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/budget_notifier.dart';
import 'package:budget_app/data/settings_notifier.dart';
import 'package:budget_app/data/transaction_notifier.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewBudgetPage extends ConsumerWidget {
  const ViewBudgetPage({super.key});

  static const String pageKey = '/view_budget_page';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passedArguments = ModalRoute.of(context)!.settings.arguments as List;

    //* Retrieving the selected index data
    final String year = passedArguments[1];
    final String month = passedArguments[2];
    final String fileName = passedArguments[3];

    final CustomButton customButton = CustomButton();
    final CustomSnackbar customSnackbar = CustomSnackbar();
    final CustomAppBar customAppBar = CustomAppBar();
    final CustomDialog customDialog = CustomDialog();

    //* Gets the devices screen width and returns it
    final deviceWidth = MediaQuery.of(context).size.width;
    final TextStyle mainTextStyle = TextStyle(
      fontSize: deviceWidth * 0.0650,
      fontWeight: FontWeight.bold,
    );
    final TextStyle textStyle = TextStyle(
      fontSize: deviceWidth * 0.040,
    );

    final iconSize = deviceWidth * 0.08;

    var language = ref.watch(notiProvLanguages);
    var index = ref.watch(notiProvLanguageIndex);
    var transactionData = ref.watch(
      asyncTransactionProvider(
        passedArguments[0],
      ),
    );

    var indexValue = 0;

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

    var noTransactions = language[indexValue]![Constants.noTransactionText]!;
    var delete = language[indexValue]![Constants.deleteText]!;
    var confirm = language[indexValue]![Constants.dialogConfirmText]!;
    var deny = language[indexValue]![Constants.dialogDenyText]!;
    var deleteFile = language[indexValue]![Constants.dialogFileDeleteText]!;
    var budgetFileDelete =
        language[indexValue]![Constants.budgetFileDeletedText]!;

    return Scaffold(
      appBar: customAppBar.showAppBar(
        leading: IconButton(
          iconSize: iconSize,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "$month $year",
              style: mainTextStyle,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: transactionData.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Column(
                      children: [
                        Expanded(
                          child: Text(
                            noTransactions,
                            style: textStyle,
                          ),
                        ),
                      ],
                    );
                  }
                  return BudgetList(
                    transactionData: data,
                    fileName: fileName,
                    selectedBudgetIndex: passedArguments[0],
                  );
                },
                loading: () => const SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stackTrace) => Text(error.toString()),
              ),
            ),
            customButton.showButton(
              context: context,
              text: delete,
              width: double.infinity,
              onPress: () async {
                customDialog
                    .showDialogBuilder(
                  context: context,
                  title: delete,
                  content: deleteFile,
                  confirm: confirm,
                  deny: deny,
                )
                    .then(
                  (value) async {
                    if (value == true) {
                      if (passedArguments[0] == 0) {
                        await ref
                            .read(asyncTransactionProvider(passedArguments[0])
                                .notifier)
                            .deleteTransaction(
                                budgetName: fileName,
                                index: passedArguments[0]);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          customSnackbar.showSnackBar(
                              context, budgetFileDelete, 1000);
                        }
                      } else if (passedArguments[0] > 0) {
                        ref.read(indexValueProvider.notifier).state = 0;
                        //* Only shows create button if user deleted
                        if (passedArguments[4] - 1 == passedArguments[0] &&
                            isAfter28th) {
                          await ref
                              .read(notiProvIsNextBudgetCreated.notifier)
                              .setIsCreatedValue(false);
                        }

                        await ref
                            .read(asyncBudgetProvider.notifier)
                            .deleteSpecificLine(
                              lineNumber: passedArguments[0],
                            );

                        await ref
                            .read(asyncBudgetProvider.notifier)
                            .deleteBudget(fileName: fileName);

                        if (context.mounted) {
                          Navigator.of(context).pop();
                          customSnackbar.showSnackBar(
                              context, budgetFileDelete, 1000);
                        }
                      }
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class BudgetList extends ConsumerWidget {
  const BudgetList({
    super.key,
    required this.transactionData,
    required this.fileName,
    required this.selectedBudgetIndex,
  });

  final List<Transaction> transactionData;
  final String fileName;
  final int selectedBudgetIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //* Gets the devices screen width and returns it
    var deviceWidth = MediaQuery.of(context).size.width;
    TextStyle textStyle = TextStyle(
      fontSize: deviceWidth * 0.040,
      fontWeight: FontWeight.bold,
    );
    TextStyle subtextStyle = TextStyle(
      fontSize: deviceWidth * 0.040,
    );

    var language = ref.watch(notiProvLanguages);
    var indexValue = ref.watch(notiProvLanguageIndex);
    var index = indexValue.asData?.value;
    var income = language[index]![Constants.incomeText]!;
    var expense = language[index]![Constants.expenseText]!;
    var balance = language[index]![Constants.balanceText]!;

    double totalIncome = 0.00, totalExpense = 0.00, totalBalance = 0.00;

    for (int i = 0; i < transactionData.length; i++) {
      if (transactionData[i].transactionType == Constants.transactionType[0]) {
        totalIncome += transactionData[i].amount;
      } else if (transactionData[i].transactionType ==
          Constants.transactionType[1]) {
        totalExpense += transactionData[i].amount;
      }

      totalBalance = totalIncome - totalExpense;
    }

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: ListView.separated(
            itemCount: transactionData.length,
            itemBuilder: (context, index) {
              String currentTransaction = '';
              if (transactionData[index].transactionType ==
                  Constants.transactionType[0]) {
                currentTransaction = income;
              } else {
                currentTransaction = expense;
              }
              return ListTile(
                visualDensity: VisualDensity.compact,
                title: Text(
                  currentTransaction,
                  style: textStyle,
                ),
                subtitle: Text(
                  transactionData[index].note,
                  overflow: TextOverflow.ellipsis,
                  style: subtextStyle,
                ),
                trailing: Text(
                  "${Constants.keyCurrency} ${transactionData[index].amount.toStringAsFixed(2)}",
                  style: textStyle,
                ),
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
          flex: 1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
                '$balance:   ${Constants.keyCurrency} ${totalBalance.toStringAsFixed(2)}',
                style: textStyle),
          ),
        )
      ],
    );
  }
}
