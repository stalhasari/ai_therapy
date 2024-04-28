import 'package:ai_therapy/widgets/message_dialog.dart';
import 'package:flutter/material.dart';

Future<bool?> showMessageDialog({
  required BuildContext context,
  required String message,
}) {
  return showDialog<bool?>(
    context: context,
    builder: (_) => MessageDialog(message: message),
  );
}