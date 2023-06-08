// ignore_for_file: use_build_context_synchronously

import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/main.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:chat_buddy/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/utils/app_utility.dart';

class ResetPasswordPage extends StatefulWidget {
  static const routeName = '/reset-password-page';
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _otpController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String otp = _otpController.text.trim();
      String password = _passwordController.text.trim();
      String passwordConfirm = _confirmPasswordController.text.trim();

      // Reset form fields
      _passwordController.clear();
      _confirmPasswordController.clear();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Coloors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  FittedBox(
                    child: Text(
                      "OTP has been sent to your email ${AppUtility.partiallyObscureEmail(widget.email)}.",
                      style: const TextStyle(
                          fontSize: 18, color: Coloors.inactiveTextGrey),
                    ),
                  ),
                  const SizedBox(height: 40),
                  MyTextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    label: 'OTP',
                    hintText: '0000',
                    obscureText: false,
                    isEnabled: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the OTP';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    label: 'Password',
                    hintText: 'Password',
                    obscureText: true,
                    isEnabled: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextFormField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    label: 'Confirm password',
                    hintText: 'password',
                    obscureText: true,
                    isEnabled: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password.';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  _isLoading
                      ? const Loading()
                      : MyButton(
                          buttonText: 'Reset Password',
                          onTap: () => _submitForm(context),
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
        ),
      ),
    );
  }
}
