import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
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

  void _onRegisterSubmit() async {
    setState(() {
      _isLoading = true;
    });

    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String passwordConfirm = confirmPasswordController.text;

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .register(name, email, password, passwordConfirm);
    } on HttpException catch (e) {
      _showErrorDialog(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
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
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              const Center(
                child: SizedBox(
                  width: 100,
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
                'Register',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Coloors.rustOrange,
                  fontSize: 45,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'Sign Up to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              MyTextField(
                controller: nameController,
                hintText: 'Enter full name',
                obscureText: false,
              ),
              const SizedBox(height: 30),
              MyTextField(
                controller: emailController,
                hintText: 'Enter email address',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: passwordController,
                hintText: 'Enter password here',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm password',
                obscureText: true,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Loading()
                  : MyButton(
                      buttonText: 'Register',
                      onTap: _onRegisterSubmit,
                    ),
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Coloors.inactiveTextGrey),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _isLoading ? () {} : widget.onTap,
                    child: const Text(
                      "Login now.",
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
