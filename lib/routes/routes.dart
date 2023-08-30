import 'package:budget_app/views/screens.dart';
import 'package:flutter/material.dart';

//*Named Navigation routes for the application
var appRoutes = {
  StartPage.pageKey: (BuildContext context) => const StartPage(),
  HomePage.pageKey: (BuildContext context) => const HomePage(),
  AddExpensePage.pageKey: (BuildContext context) => const AddExpensePage(),
  EditExpensePage.pageKey: (BuildContext context) => const EditExpensePage(),
  AddIncomePage.pageKey: (BuildContext context) => const AddIncomePage(),
  EditIncomePage.pageKey: (BuildContext context) => const EditIncomePage(),
  SettingsPage.pageKey: (BuildContext context) => const SettingsPage(),
  ViewBudgetPage.pageKey: (BuildContext context) => const ViewBudgetPage(),
  PassCreatePage.pageKey: (BuildContext context) => const PassCreatePage(),
  PassLoginPage.pageKey: (BuildContext context) => const PassLoginPage(),
  PassForgotPage.pageKey: (BuildContext context) => const PassForgotPage(),
};
