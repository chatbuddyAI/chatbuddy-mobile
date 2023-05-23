import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:flutter/material.dart';

class AppUtility {
  static void showErrorDialog(
      {required BuildContext context, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('An Error Occured!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }

  static void showSuccessDialog(
      {required BuildContext context, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }

  static void areYouSureDialog(
      {required BuildContext context,
      required String prompt,
      required Function() yes,
      Function()? no}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("Do you really want to cancel your subscription?"),
        actions: [
          TextButton(
            onPressed: no ??
                () {
                  Navigator.of(context).pop();
                },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: yes,
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}
