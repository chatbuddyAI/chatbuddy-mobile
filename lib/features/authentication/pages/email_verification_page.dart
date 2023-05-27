// ignore_for_file: use_build_context_synchronously

import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/features/authentication/pages/login_or_register_page.dart';
import 'package:chat_buddy/features/authentication/pages/reset_password_page.dart';
import 'package:chat_buddy/models/Auth_model.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../widgets/my_text_field.dart';

class EmailVerificationPage extends StatefulWidget {
  static const routeName = '/email-verification-page';

  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isLoading = false;
  final otpController = TextEditingController();

  void _resendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false).sendOtp();

      AppUtility.showSuccessDialog(
          context: context, message: 'Resent OTP successfully');
    } on HttpException catch (e) {
      AppUtility.showErrorDialog(context: context, message: e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onOtpSubmit() async {
    setState(() {
      _isLoading = true;
    });

    String otp = otpController.text.trim();

    try {
      final message = await Provider.of<AuthProvider>(context, listen: false)
          .verifyOtp(otp);

      AppUtility.showSuccessDialog(context: context, message: message);
    } on HttpException catch (e) {
      AppUtility.showErrorDialog(context: context, message: e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Email Verifiaction',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Coloors.rustOrange,
                fontSize: 35,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "OTP has been sent to your email ${AppUtility.partiallyObscureEmail(widget.email)}.",
              style: const TextStyle(color: Coloors.inactiveTextGrey),
            ),
            const SizedBox(height: 30),
            MyTextField(
              controller: otpController,
              label: 'OTP',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Loading()
                : MyButton(
                    buttonText: 'Verify Email',
                    onTap: _onOtpSubmit,
                  ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Have not recieved OTP? ",
                  style: TextStyle(color: Coloors.inactiveTextGrey),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: _isLoading ? () {} : _resendOtp,
                  child: Text(
                    "Resend now.",
                    style: TextStyle(
                      color: _isLoading ? Coloors.greyLight : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
