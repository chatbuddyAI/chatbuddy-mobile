import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:flutter/material.dart';

import '../widgets/my_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Coloors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 7),
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
                hintText: 'Enter email address',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: passwordController,
                hintText: 'Enter password here',
                obscureText: true,
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              MyButton(
                buttonText: 'Login',
                onTap: () {},
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String buttonText;
  final Function()? onTap;

  const MyButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: Coloors.rustOrange, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
