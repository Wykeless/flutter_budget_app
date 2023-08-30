import 'package:flutter/material.dart';

class CustomSnackbar {
  void showSnackBar(BuildContext context, String text, int? ms) {
    //* Gets the devices screen width and returns it
    var deviceWidth = MediaQuery.of(context).size.width;
    TextStyle textStyle = TextStyle(
      fontSize: deviceWidth * 0.040,
      fontWeight: FontWeight.bold,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xff33b6e7),
          duration: Duration(milliseconds: ms ??= 1500),
          content: Text(
            text,
            style: textStyle,
          ),
        ),
      );
    }
  }
}
