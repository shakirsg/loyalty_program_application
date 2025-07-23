import 'package:flutter/material.dart';

/// Runs an async [action] while showing a loading dialog.
/// The dialog is automatically dismissed when the action completes or throws.
Future<void> showLoadingDialogWhile({
  required BuildContext context,
  required Future<void> Function() action,
}) async {
  // Show the loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    // Execute the async operation
    await action();
  } finally {
    // Close the loading dialog
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
  }
}
