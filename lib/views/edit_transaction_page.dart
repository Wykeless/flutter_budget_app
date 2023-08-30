import 'dart:developer';

import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/data/settings_notifier.dart';
import 'package:budget_app/data/transaction_notifier.dart';
import 'package:budget_app/models/transaction_model.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//* This is the types of pages
enum EditPageType { editIncome, editExpense }

class EditTransactionPage extends ConsumerStatefulWidget {
  const EditTransactionPage({super.key, required this.pageType});

  final EditPageType pageType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditTransactionPageState();
}

class _EditTransactionPageState extends ConsumerState<EditTransactionPage> {
  final DatePicker _datePicker = DatePicker();
  CustomAppBar customAppBar = CustomAppBar();
  final CustomSnackbar _customSnackbar = CustomSnackbar();
  final CustomButton _customButton = CustomButton();
  final CustomDialog _customDialog = CustomDialog();

  final TextEditingController _dateTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _noteTextController = TextEditingController();
  late final List<dynamic> passedArguments;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      passedArguments = ModalRoute.of(context)!.settings.arguments as List;
      _dateTextController.text = passedArguments[3];
      _amountTextController.text = passedArguments[4];
      _noteTextController.text = passedArguments[5];
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dateTextController.dispose();
    _amountTextController.dispose();
    _noteTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //* Gets the devices screen width and returns it
    var deviceWidth = MediaQuery.of(context).size.width;
    var iconSize = deviceWidth * 0.08;

    TextStyle textStyle = TextStyle(fontSize: deviceWidth * 0.040);
    TextStyle mainTextStyle = TextStyle(
      fontSize: deviceWidth * 0.07,
      fontWeight: FontWeight.bold,
    );

    var pagesType = ref.watch(notiProvEditPageTypeLanguage);
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
    var page = pagesType[indexValue]![widget.pageType.index];
    var date = language[indexValue]![Constants.dateText]!;
    var amount = language[indexValue]![Constants.amountText]!;
    var note = language[indexValue]![Constants.noteText]!;
    var emptyFields = language[indexValue]![Constants.emptyFieldsText]!;
    var save = language[indexValue]![Constants.saveText]!;
    var delete = language[indexValue]![Constants.deleteText]!;
    var confirm = language[indexValue]![Constants.dialogConfirmText]!;
    var deny = language[indexValue]![Constants.dialogDenyText]!;
    var deleteTransaction =
        language[indexValue]![Constants.dialogTransDeleteText]!;

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
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: textStyle,
                            focusNode: AlwaysDisabledFocusNode(),
                            controller: _dateTextController,
                            onTap: () {
                              _datePicker.selectDate(
                                  context, _dateTextController);
                            },
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: IconButton(
                            icon: const Icon(Icons.date_range_sharp),
                            //* adds current date when you click it
                            onPressed: () {
                              _datePicker.setCurrentDate(_dateTextController);
                            },
                          ),
                        )
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
                            style: textStyle,
                            maxLength: 12,
                            inputFormatters: [
                              //* Formats the Text input and only allows numbers and 2 decimals
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            controller: _amountTextController,
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
                            textAlign: TextAlign.center,
                            maxLength: 30,
                            style: textStyle,
                            controller: _noteTextController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _customButton.showButton(
                          context: context,
                          text: delete,
                          width: double.infinity,
                          onPress: () async {
                            _customDialog
                                .showDialogBuilder(
                              context: context,
                              title: delete,
                              content: deleteTransaction,
                              confirm: confirm,
                              deny: deny,
                            )
                                .then(
                              (value) async {
                                if (value == true) {
                                  if (passedArguments[6] == 1) {
                                    await ref
                                        .read(asyncTransactionProvider(
                                                passedArguments[0])
                                            .notifier)
                                        .deleteTransaction(
                                          budgetName: passedArguments[1],
                                          index: passedArguments[0],
                                        );
                                  } else {
                                    await ref
                                        .read(asyncTransactionProvider(
                                                passedArguments[0])
                                            .notifier)
                                        .deleteSpecificLine(
                                          fileName: passedArguments[1],
                                          lineNumber: passedArguments[2],
                                          budgetIndex: passedArguments[0],
                                        );
                                  }

                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    _customSnackbar.showSnackBar(
                                        context, 'Transaction Deleted', 1500);
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 80,
                      ),
                      Expanded(
                        child: _customButton.showButton(
                          context: context,
                          text: save,
                          width: double.infinity,
                          onPress: () async {
                            // *: Saves info to textfile
                            if (_dateTextController.text.trim().isEmpty ||
                                _amountTextController.text.trim().isEmpty ||
                                _noteTextController.text.trim().isEmpty) {
                              _customSnackbar.showSnackBar(
                                  context, emptyFields, null);
                            } else {
                              await ref
                                  .read(asyncTransactionProvider(
                                          passedArguments[0])
                                      .notifier)
                                  .editALine(
                                    newDataToWrite: Transaction(
                                      transactionType:
                                          Constants.transactionType[
                                              widget.pageType.index],
                                      date: _dateTextController.text.trim(),
                                      amount: double.parse(
                                        double.parse(
                                          _amountTextController.text.trim(),
                                        ).toStringAsFixed(2),
                                      ),
                                      note: _noteTextController.text.trim(),
                                    ),
                                    fileName: passedArguments[1],
                                    lineNumber: passedArguments[2],
                                    budgetIndex: passedArguments[0],
                                  );

                              if (context.mounted) {
                                Navigator.of(context).pop();
                                _customSnackbar.showSnackBar(
                                    context, 'Transaction Updated', 1500);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
