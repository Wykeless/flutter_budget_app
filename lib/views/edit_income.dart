import 'package:budget_app/views/edit_transaction_page.dart';
import 'package:flutter/material.dart';

class EditIncomePage extends StatefulWidget {
  const EditIncomePage({super.key});

  static const String pageKey = '/edit_income';

  @override
  State<EditIncomePage> createState() => _EditIncomePageState();
}

class _EditIncomePageState extends State<EditIncomePage> {
  @override
  Widget build(BuildContext context) {
    return const EditTransactionPage(pageType: EditPageType.editIncome);
  }
}
