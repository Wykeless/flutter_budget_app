import 'package:flutter/material.dart';

class CustomButton {
  ElevatedButton showButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPress,
    double? width,
  }) {
    //* Gets the devices screen width and returns it
    var deviceWidth = MediaQuery.of(context).size.width;
    TextStyle buttonTextStyle = TextStyle(fontSize: deviceWidth * 0.045);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff474747),
        minimumSize: Size(width ?? 120, 45),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2),
          ),
        ),
      ),
      onPressed: onPress,
      child: Text(
        text,
        style: buttonTextStyle,
      ),
    );
  }
}
