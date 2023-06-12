// ignore_for_file: use_build_context_synchronously

import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:chat_buddy/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailVerificationPage extends StatefulWidget {
  static const routeName = '/email-verification-page';

  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _logoutUser(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String otp = _otpController.text.trim();

      setState(() {
        _isLoading = true;
      });

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
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                FittedBox(
                  child: Text(
                    "OTP has been sent to your email ${AppUtility.partiallyObscureEmail(widget.email)}.",
                    style: const TextStyle(
                        fontSize: 18, color: Coloors.inactiveTextGrey),
                  ),
                ),
                const SizedBox(height: 30),
                MyTextFormField(
                  controller: _otpController,
                  label: 'OTP',
                  hintText: '0000',
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  isEnabled: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the OTP sent to your email for verification';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Loading()
                    : MyButton(
                        buttonText: 'Verify Email',
                        onTap: () => _submitForm(context),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have not recieved OTP? ",
                      style: TextStyle(
                          fontSize: 18, color: Coloors.inactiveTextGrey),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: _isLoading ? () {} : _resendOtp,
                      child: Text(
                        "Resend now.",
                        style: TextStyle(
                          fontSize: 18,
                          color: _isLoading
                              ? Coloors.inactiveTextGrey
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: GestureDetector(
                    onTap: () => _isLoading ? () {} : _logoutUser(context),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 251, 19, 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
