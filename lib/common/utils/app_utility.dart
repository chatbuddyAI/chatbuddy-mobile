import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static void showInfoDialog(
      {required BuildContext context, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Info!'),
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

  static Future areYouSureDialog(
      {required BuildContext context,
      required String prompt,
      required Function() yes,
      Function()? no}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        content: Text(prompt),
        actions: [
          TextButton(
            onPressed: no ??
                () {
                  Navigator.of(context).pop(false);
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

  static String partiallyObscureEmail(String text) {
    var emailParts = text.split('@');

    return "${emailParts[0].substring(0, 2)}****${emailParts[1].substring(3)}";
  }

  static Future urlLauncher(url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  static bool isFullNameValid(String fullName) {
    List<String> nameParts = fullName.trim().split(' ');

    for (var namePart in nameParts) {
      // check if the name contains at least two words
      if (namePart.length < 2 || namePart.contains('.')) {
        return false;
      }
    }

    return nameParts.length >= 2;
  }
}
