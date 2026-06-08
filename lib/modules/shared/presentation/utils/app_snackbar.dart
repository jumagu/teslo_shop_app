import 'package:flutter/material.dart';

enum MessageTone { success, error }

class SnackbarMessage {
  final String text;
  final MessageTone tone;

  SnackbarMessage(this.text, this.tone);
}

Map<MessageTone, Color> toneColors = {
  MessageTone.success: const Color.fromARGB(255, 27, 193, 18),
  MessageTone.error: const Color.fromRGBO(244, 67, 54, 1),
};

void showSnackbar(
  BuildContext context,
  SnackbarMessage message, [
  Duration duration = const Duration(seconds: 3),
]) {
  ScaffoldMessenger.of(context).clearSnackBars();

  final SnackBar snackBar = SnackBar(
    content: Text(message.text),
    duration: duration,
    backgroundColor: toneColors[message.tone],
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
