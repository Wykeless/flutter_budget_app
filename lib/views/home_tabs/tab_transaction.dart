import 'dart:developer';

import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/settings_notifier.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/views/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionTab extends ConsumerWidget {
  const TransactionTab({
    super.key,
    required this.transactionData,
    required this.currentFileName,
    required this.budgetIndex,
  });

  final AsyncValue<List<Transaction>> transactionData;
  final String currentFileName;
  final int budgetIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //* Gets the devices screen width and returns it
    var deviceWidth = MediaQuery.of(context).size.width;

    TextStyle textStyle = TextStyle(fontSize: deviceWidth * 0.040);

    var language = ref.watch(notiProvLanguages);
    var index = ref.watch(notiProvLanguageIndex);
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
    var getStartedTwoText = language[indexValue]![Constants.getStartedTwoText]!;

    return transactionData.when(
      data: (transactionData) {
        if (transactionData.isEmpty) {
          return Text(
            getStartedTwoText,
            style: textStyle,
          );
        }
        return TransactionList(
          transactionData: transactionData,
          budgetIndex: budgetIndex,
          currentFileName: currentFileName,
        );
      },
      loading: () => const SizedBox(
        height: 150,
        width: 150,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) {
        log('Error loading data: $error');
        return Text(error.toString());
      },
    );
  }
}

class TransactionList extends ConsumerWidget {
  const TransactionList(
      {super.key,
      required this.transactionData,
      required this.budgetIndex,
      required this.currentFileName});

  final List<Transaction> transactionData;
  final String currentFileName;
  final int budgetIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //* Gets the devices screen width and returns it
    var deviceWidth = MediaQuery.of(context).size.width;
    TextStyle textStyle = TextStyle(fontSize: deviceWidth * 0.038);
    return ListView.separated(
      itemCount: transactionData.length,
      itemBuilder: (context, lineIndex) {
        return InkWell(
          onTap: () {
            List<dynamic> argumentsToPass = [
              budgetIndex,
              currentFileName,
              lineIndex,
              transactionData[lineIndex].date,
              transactionData[lineIndex].amount.toStringAsFixed(2),
              transactionData[lineIndex].note,
              transactionData.length,
            ];

            if (transactionData[lineIndex].transactionType ==
                Constants.transactionType[0]) {
              Navigator.of(context).pushNamed(
                EditIncomePage.pageKey,
                arguments: argumentsToPass,
              );
            } else if (transactionData[lineIndex].transactionType ==
                Constants.transactionType[1]) {
              Navigator.of(context).pushNamed(
                EditExpensePage.pageKey,
                arguments: argumentsToPass,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    transactionData[lineIndex].note,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "${Constants.keyCurrency} ${transactionData[lineIndex].amount.toStringAsFixed(2)}",
                    style: textStyle,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
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
    );
  }
}
