import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/utils/app_utility.dart';
import '../../../widgets/my_text_form_field.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      // Reset form fields
      _passwordController.clear();

      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(email, password);
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
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 20),
                const Center(
                  child: SizedBox(
                    // width: 100,
                    child: Text(
                      'CHAT BUDDY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Coloors.rustOrange,
                    fontSize: 45,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Sign in to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                MyTextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'example@example.com',
                  label: 'Email address',
                  obscureText: false,
                  isEnabled: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                MyTextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  label: 'Password',
                  hintText: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                  isEnabled: true,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Loading()
                    : MyButton(
                        buttonText: 'Login',
                        onTap: () => _submitForm(context),
                      ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                          fontSize: 18, color: Coloors.inactiveTextGrey),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: _isLoading ? () {} : widget.onTap,
                      child: const Text(
                        "Register now.",
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: GestureDetector(
                    onTap: () => _isLoading
                        ? () {}
                        : Navigator.pushNamed(
                            context, ForgotPasswordPage.routeName),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
