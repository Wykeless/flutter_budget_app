import 'package:budget_app/views/add_transaction_page.dart';
import 'package:flutter/material.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  static const String pageKey = '/add_expense';

  @override
  Widget build(BuildContext context) {
    return const AddTransactionPage(pageType: AddPageType.addExpense);
  }
}
