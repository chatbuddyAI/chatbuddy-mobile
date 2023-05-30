import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/features/authentication/pages/reset_password_page.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/my_text_field.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  void _showErrorDialog(String message) {
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

  void _onLoginSubmit() async {
    setState(() {
      _isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(email, password);
    } on HttpException catch (e) {
      _showErrorDialog(e.toString());
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
            mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(height: 30),
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
              const SizedBox(height: 30),
              MyTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                label: 'Email address',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                label: 'Password',
                obscureText: true,
              ),
              GestureDetector(
                onTap: _isLoading ? () {} : () {},
                child: Container(
                  alignment: Alignment.bottomRight,
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
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Loading()
                  : MyButton(
                      buttonText: 'Login',
                      onTap: _onLoginSubmit,
                    ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Coloors.inactiveTextGrey),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _isLoading ? () {} : widget.onTap,
                    child: const Text(
                      "Register now.",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
