import 'dart:developer';

import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/budget_notifier.dart';
import 'package:budget_app/data/settings_notifier.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/views/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({
    super.key,
    required this.transactionData,
    required this.currentFileName,
    required this.index,
  });

  final AsyncValue<List<Transaction>> transactionData;
  final String currentFileName;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //* Gets the devices screen width
    var deviceWidth = MediaQuery.of(context).size.width;
    TextStyle textStyle = TextStyle(fontSize: deviceWidth * 0.040);
    var iconSize = deviceWidth * 0.14;

    //* Variables to calculate transaction totals
    double totalIncome = 0.00, totalExpense = 0.00, totalBalance = 0.00;

    //* Provider watchers
    var language = ref.watch(notiProvLanguages);
    var index = ref.watch(notiProvLanguageIndex);
    var budgetIndex = ref.watch(indexValueProvider);
    var indexValue = 0;

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
    var getStarted = language[indexValue]![Constants.getStartedHomeText]!;
    var income = language[indexValue]![Constants.incomeText]!;
    var expense = language[indexValue]![Constants.expenseText]!;
    var balance = language[indexValue]![Constants.balanceText]!;

    return Column(
      children: [
        Expanded(
          child: transactionData.when(
            data: (transactionData) {
              //* If there is no data show user how to get started
              if (transactionData.isEmpty) {
                return Text(
                  getStarted,
                  style: textStyle,
                );
              }
              if (transactionData.isNotEmpty) {
                //* Calculates the total income,expense and total balance values
                for (int i = 0; i < transactionData.length; i++) {
                  if (transactionData[i].transactionType ==
                      Constants.transactionType[0]) {
                    totalIncome += transactionData[i].amount;
                  } else if (transactionData[i].transactionType ==
                      Constants.transactionType[1]) {
                    totalExpense += transactionData[i].amount;
                  }

                  totalBalance = totalIncome - totalExpense;
                }
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        income,
                        style: textStyle,
                      ),
                      Text(
                        totalIncome.toStringAsFixed(2),
                        style: textStyle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        expense,
                        style: textStyle,
                      ),
                      Text(
                        totalExpense.toStringAsFixed(2),
                        style: textStyle,
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 25,
                    thickness: 0.5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        balance,
                        style: textStyle,
                      ),
                      Text(
                        "${Constants.keyCurrency} ${totalBalance.toStringAsFixed(2)}",
                        style: textStyle,
                      )
                    ],
                  ),
                ],
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
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    expense,
                    style: textStyle,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (context.mounted) {
                        Navigator.of(context).pushNamed(
                          AddExpensePage.pageKey,
                          arguments: [
                            budgetIndex,
                            currentFileName,
                          ],
                        );
                      }
                    },
                    icon: Icon(Icons.add, size: iconSize),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    income,
                    style: textStyle,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (context.mounted) {
                        Navigator.of(context)
                            .pushNamed(AddIncomePage.pageKey, arguments: [
                          budgetIndex,
                          currentFileName,
                        ]);
                      }
                    },
                    icon: Icon(Icons.add, size: iconSize),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
