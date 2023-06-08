import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/utils/app_utility.dart';
import '../../../widgets/my_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool isFullNameValid(String fullName) {
    List<String> nameParts = fullName.trim().split(' ');

    for (var namePart in nameParts) {
      // check if the name contains at least two words
      if (namePart.length < 2 || namePart.contains('.')) {
        return false;
      }
    }

    return nameParts.length >= 2;
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String name = _fullNameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      // Reset form fields

      _passwordController.clear();
      _confirmPasswordController.clear();

      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .register(name, email, password, confirmPassword);
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
                    const SizedBox(height: 20),
                    MyTextFormField(
                      controller: _fullNameController,
                      keyboardType: TextInputType.name,
                      label: 'Full Name',
                      hintText: 'John Doe',
                      obscureText: false,
                      isEnabled: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your full name';
                        }
                        // Custom validation logic, if needed
                        if (!isFullNameValid(value)) {
                          return 'Please enter a valid full name';
                        }
                        return null; // Return null to indicate no error
                      },
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
                    MyTextFormField(
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      label: 'Confirm password',
                      hintText: 'Password',
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
                    const SizedBox(height: 20),
                    _isLoading
                        ? const Loading()
                        : MyButton(
                            buttonText: 'Register',
                            onTap: () => _submitForm(context),
                          ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontSize: 18, color: Coloors.inactiveTextGrey),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: _isLoading ? () {} : widget.onTap,
                          child: const Text(
                            "Login now.",
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
