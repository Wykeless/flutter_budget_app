import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker {
  DateTime? _selectedDate;

  void selectDate(
      BuildContext context, TextEditingController textEditingController) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            cardColor: Colors.orange, // Today's highlighted date color
            primaryTextTheme: const TextTheme(
              titleLarge: TextStyle(
                color: Colors.black, // Header text color
              ),
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                color: Colors.black, // Date text color
              ),
              titleMedium: TextStyle(
                color: Colors.black87, // Weekday text color
              ),
              bodyLarge: TextStyle(
                color: Colors.black, // Customize the year picker text color
              ),
              bodyMedium: TextStyle(
                color: Colors.black, // Customize the year picker text color
              ),
            ),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: const Color(0xFF33B6E7)),
          ),
          child: child!,
        );
      },
    );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      String formattedDate = DateFormat('dd MMMM yyyy').format(_selectedDate!);
      textEditingController
        ..text = formattedDate
        ..selection = TextSelection.fromPosition(
          TextPosition(
            offset: textEditingController.text.length,
            affinity: TextAffinity.upstream,
          ),
        );
    }
  }

  void setCurrentDate(TextEditingController textEditingController) {
    String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
    textEditingController
      ..text = formattedDate
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: textEditingController.text.length,
          affinity: TextAffinity.upstream,
        ),
      );
  }
}
