import 'dart:async';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FileManager fileManager = FileManager();

//*Provides a way to watch the data
final asyncTransactionProvider = AsyncNotifierProvider.autoDispose
    .family<TransactionNotifier, List<Transaction>, int>(
  () => TransactionNotifier(),
);

class TransactionNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Transaction>, int> {
  //* loads initial data if there is any
  Future<List<Transaction>> _readTransactionData(int budgetIndex) async {
    final budgetFile = await fileManager
        .readDataFromBudgetManagerFile(Constants.fileBudgetManager);
    final dataList = await fileManager.readDataFromTxnsFile(
      budgetFile[budgetIndex].budgetName,
    );

    return dataList;
  }

  //* Uses the initial data to build the state
  @override
  Future<List<Transaction>> build(int arg) {
    return _readTransactionData(arg);
  }

  //* add a new line of data
  Future<void> addData({
    required Transaction dataToWrite,
    required String fileName,
    required int budgetIndex,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () {
        fileManager.writeDataToTxnsFile(
          txnData: dataToWrite,
          fileName: fileName,
        );
        return _readTransactionData(budgetIndex);
      },
    );
  }

  //* edit a line of data
  Future<void> editALine({
    required Transaction newDataToWrite,
    required String fileName,
    required int lineNumber,
    required int budgetIndex,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () {
        fileManager.editLineInFile(
          fileName: fileName,
          lineNumber: lineNumber,
          newData: newDataToWrite,
        );
        return _readTransactionData(budgetIndex);
      },
    );
  }

  //* Delete a line of data
  Future<void> deleteSpecificLine({
    required String fileName,
    required int lineNumber,
    required int budgetIndex,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () {
        fileManager.deleteLineFromFile(
          fileName: fileName,
          lineNumber: lineNumber,
        );
        return _readTransactionData(budgetIndex);
      },
    );
  }

  //* Deletes the budget from the device
  Future<void> deleteTransaction({
    required String budgetName,
    required int index,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () {
        fileManager.deleteFile(fileName: budgetName);
        return _readTransactionData(index);
      },
    );
  }
}
