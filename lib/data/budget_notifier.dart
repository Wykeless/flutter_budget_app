import 'dart:async';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/utils/file_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final fileManager = FileManager();
final indexValueProvider = StateProvider<int>((ref) => 0);

final asyncBudgetProvider =
    AsyncNotifierProvider.autoDispose<BudgetNotifier, List<Budget>>(
  () => BudgetNotifier(),
);

class BudgetNotifier extends AutoDisposeAsyncNotifier<List<Budget>> {
  //* loads initial data if there is any
  Future<List<Budget>> _readBudgetData() async {
    final budgetFile = await fileManager.readDataFromBudgetManagerFile(
      Constants.fileBudgetManager,
    );

    ref.read(indexValueProvider.notifier).state = budgetFile.length - 1;

    return budgetFile;
  }

  //*Uses the initial data to build the state
  @override
  Future<List<Budget>> build() async {
    return _readBudgetData();
  }

  //* Saves budget
  Future<void> saveBudget({
    String? year,
    String? month,
    bool? isNewWrite,
  }) async {
    year ??= DateFormat('yyyy').format(DateTime.now());
    month ??= "${DateTime.now().month - 1}";
    String newFileName = "$year$month.txt";

    Budget newBudget = Budget(
      year: year,
      month: month,
      budgetName: newFileName,
    );

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () {
        fileManager.writeDataToBudgetManagerFile(
          budgetData: newBudget,
          fileName: Constants.fileBudgetManager,
        );
        return _readBudgetData();
      },
    );

    update((notifier) => _readBudgetData());
  }

  //* Deletes a line from budget
  Future<void> deleteSpecificLine({
    required int lineNumber,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () {
        fileManager.deleteLineFromFile(
          fileName: Constants.fileBudgetManager,
          lineNumber: lineNumber,
        );
        return _readBudgetData();
      },
    );

    update((notifier) => _readBudgetData());
  }

  //* Deletes the budget from the device
  Future<void> deleteBudget({required String fileName}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () {
        fileManager.deleteFile(fileName: fileName);
        return _readBudgetData();
      },
    );

    update((notifier) => _readBudgetData());
  }
}
