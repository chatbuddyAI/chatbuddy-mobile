// ignore_for_file: use_build_context_synchronously

import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import '../../../common/utils/app_utility.dart';
import '../widgets/my_text_field.dart';

class ResetPasswordPage extends StatefulWidget {
  static const routeName = '/reset-password-page';
  final String email;

  const ResetPasswordPage({super.key, this.email = 'test@test.com'});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final otpController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _resendOtp(email) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .forgotPassword(email);

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

  void _onResetSubmit() async {
    setState(() {
      _isLoading = true;
    });

    String otp = otpController.text;
    String password = passwordController.text;
    String passwordConfirm = confirmPasswordController.text;

    try {
      final message = await Provider.of<AuthProvider>(context, listen: false)
          .resetPassword(otp, widget.email, password, passwordConfirm);

      AppUtility.showSuccessDialog(context: context, message: message);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MyApp(),
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
      // backgroundColor: Coloors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              const Text(
                'Reset Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Coloors.rustOrange,
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "OTP has been sent to your email ${AppUtility.partiallyObscureEmail(widget.email)}.",
                style: const TextStyle(color: Coloors.inactiveTextGrey),
              ),
              const SizedBox(height: 40),
              MyTextField(
                controller: otpController,
                hintText: 'Enter OTP',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'Enter password here',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm password',
                obscureText: true,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Loading()
                  : MyButton(
                      buttonText: 'Reset Password',
                      onTap: _onResetSubmit,
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
                  _isLoading
                      ? const Loading()
                      : GestureDetector(
                          onTap: () => _resendOtp(widget.email),
                          child: const Text(
                            "Resend now.",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
