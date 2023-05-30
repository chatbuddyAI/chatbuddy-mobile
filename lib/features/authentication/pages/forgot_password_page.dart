// ignore_for_file: use_build_context_synchronously

import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/features/authentication/pages/login_or_register_page.dart';
import 'package:chat_buddy/features/authentication/pages/reset_password_page.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../widgets/my_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = '/forgot-password-page';

  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _isLoading = false;
  final emailController = TextEditingController();

  void _onForgortPasswordSubmit() async {
    setState(() {
      _isLoading = true;
    });

    String email = emailController.text.trim();

    try {
      final message = await Provider.of<AuthProvider>(context, listen: false)
          .forgotPassword(email);

      AppUtility.showSuccessDialog(context: context, message: message);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(
            email: email,
          ),
        ),
      );
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
              'Forgot Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Coloors.rustOrange,
                fontSize: 35,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 30),
            MyTextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              label: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Loading()
                : MyButton(
                    buttonText: 'Send Reset OTP',
                    onTap: _onForgortPasswordSubmit,
                  ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Remember your password?",
                  style: TextStyle(color: Coloors.inactiveTextGrey),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => _isLoading
                      ? () {}
                      : Navigator.pushNamed(
                          context,
                          LoginOrRegisterPage.routeName,
                        ),
                  child: const Text(
                    "Login.",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
