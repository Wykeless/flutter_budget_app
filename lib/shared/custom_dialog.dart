import 'package:flutter/material.dart';

class CustomDialog {
  Future<bool?> showDialogBuilder({
    required BuildContext context,
    String? title,
    required String content,
    required String deny,
    required String confirm,
  }) {
    //* Gets the devices screen width and returns it
    var deviceWidth = MediaQuery.of(context).size.width;
    var spaceSize = deviceWidth * 0.2;

    TextStyle titleTextStyle = TextStyle(
      fontSize: deviceWidth * 0.065,
      fontWeight: FontWeight.bold,
    );
    TextStyle contextTextStyle = TextStyle(fontSize: deviceWidth * 0.042);
    TextStyle buttonTextStyle = TextStyle(
      fontSize: deviceWidth * 0.055,
      color: Colors.black,
    );

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title ?? '',
            style: titleTextStyle,
          ),
          content: Text(
            content,
            style: contextTextStyle,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text(
                    deny,
                    style: buttonTextStyle,
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                SizedBox(width: spaceSize),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    confirm,
                    style: buttonTextStyle,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
