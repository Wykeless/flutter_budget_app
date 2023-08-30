import 'package:budget_app/views/edit_transaction_page.dart';
import 'package:flutter/material.dart';

class EditExpensePage extends StatefulWidget {
  const EditExpensePage({super.key});

  static const String pageKey = '/edit_expense';

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  @override
  Widget build(BuildContext context) {
    return const EditTransactionPage(pageType: EditPageType.editExpense);
  }
}
