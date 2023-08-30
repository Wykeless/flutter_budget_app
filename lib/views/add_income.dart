import 'package:budget_app/views/add_transaction_page.dart';

import 'package:flutter/material.dart';

class AddIncomePage extends StatelessWidget {
  const AddIncomePage({super.key});

  static const String pageKey = '/add_income';

  @override
  Widget build(BuildContext context) {
    return const AddTransactionPage(pageType: AddPageType.addIncome);
  }
}
