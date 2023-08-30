import 'dart:developer';

import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/settings_notifier.dart';
import 'package:budget_app/data/transaction_notifier.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//* This is the types of pages
enum AddPageType { addIncome, addExpense }

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key, required this.pageType});

  final AddPageType pageType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final DatePicker _datePicker = DatePicker();
  final CustomSnackbar _customSnackbar = CustomSnackbar();

  final TextEditingController _dateTextEditing = TextEditingController();
  final TextEditingController _amountTextEditing = TextEditingController();
  final TextEditingController _noteTextEditing = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _dateTextEditing.dispose();
    _amountTextEditing.dispose();
    _noteTextEditing.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passedArguments = ModalRoute.of(context)!.settings.arguments as List;

    int budgetIndex = passedArguments[0];
    String fileName = passedArguments[1];

    CustomAppBar customAppBar = CustomAppBar();
    CustomButton customButton = CustomButton();

    //* Gets the devices screen width and returns it
    var deviceWidth = MediaQuery.of(context).size.width;
    TextStyle textStyle = TextStyle(fontSize: deviceWidth * 0.040);
    TextStyle mainTextStyle = TextStyle(
      fontSize: deviceWidth * 0.07,
      fontWeight: FontWeight.bold,
    );

    var iconSize = deviceWidth * 0.08;

    var pagesType = ref.watch(notiProvAddPageTypeLanguage);
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
    var date = language[indexValue]![Constants.dateText]!;
    var amount = language[indexValue]![Constants.amountText]!;
    var note = language[indexValue]![Constants.noteText]!;
    var emptyFields = language[indexValue]![Constants.emptyFieldsText]!;
    var save = language[indexValue]![Constants.saveText]!;
    var page = pagesType[indexValue]![widget.pageType.index];

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    page,
                    style: mainTextStyle,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            date,
                            style: textStyle,
                          ),
                        ),
                        const SizedBox(
                          width: 23,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: textStyle,
                            focusNode: AlwaysDisabledFocusNode(),
                            controller: _dateTextEditing,
                            onTap: () {
                              _datePicker.selectDate(context, _dateTextEditing);
                            },
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: IconButton(
                            icon: const Icon(Icons.date_range_sharp),
                            // * When clicked it sets the date field to the current date
                            onPressed: () {
                              _datePicker.setCurrentDate(_dateTextEditing);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            amount,
                            style: textStyle,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            maxLength: 12,
                            style: textStyle,
                            inputFormatters: [
                              //* Formats the Text input and only allows numbers and 2 decimals
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            controller: _amountTextEditing,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            note,
                            style: textStyle,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            maxLength: 30,
                            textAlign: TextAlign.center,
                            style: textStyle,
                            controller: _noteTextEditing,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: customButton.showButton(
                  context: context,
                  text: save,
                  width: double.infinity,
                  onPress: () async {
                    // *: Saves info to textfile
                    if (_dateTextEditing.text.trim().isEmpty ||
                        _amountTextEditing.text.trim().isEmpty ||
                        _noteTextEditing.text.trim().isEmpty) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _customSnackbar.showSnackBar(context, emptyFields, null);
                    } else {
                      await ref
                          .read(asyncTransactionProvider(budgetIndex).notifier)
                          .addData(
                            dataToWrite: Transaction(
                              transactionType: Constants
                                  .transactionType[widget.pageType.index],
                              date: _dateTextEditing.text.trim(),
                              amount: double.parse(
                                double.parse(
                                  _amountTextEditing.text.trim(),
                                ).toStringAsFixed(2),
                              ),
                              note: _noteTextEditing.text.trim(),
                            ),
                            fileName: fileName,
                            budgetIndex: budgetIndex,
                          );

                      if (context.mounted) {
                        Navigator.of(context).pop();
                        _customSnackbar.showSnackBar(
                            context, 'Transaction Saved', 1500);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
