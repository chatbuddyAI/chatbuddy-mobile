// ignore_for_file: use_build_context_synchronously

import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/my_text_form_field.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Perform password change logic here
      String oldPassword = _oldPasswordController.text.trim();
      String newPassword = _newPasswordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      // Reset form fields
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .changePassword(oldPassword, newPassword, confirmPassword)
            .then((value) => null);
        AppUtility.showSuccessDialog(
            context: context, message: 'Password changed successfully!');
      } on HttpException catch (e) {
        AppUtility.showErrorDialog(context: context, message: e.message);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !_isLoading;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isLoading)
            SizedBox(height: 70, width: 70, child: const Loading()),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8.0),
                  MyTextFormField(
                    controller: _oldPasswordController,
                    obscureText: true,
                    isEnabled: !_isLoading,
                    label: 'Old Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your old password.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 8.0),
                  MyTextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    isEnabled: !_isLoading,
                    keyboardType: TextInputType.visiblePassword,
                    label: 'New Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  MyTextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    isEnabled: !_isLoading,
                    keyboardType: TextInputType.visiblePassword,
                    label: 'Confirm Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password.';
                      } else if (value != _newPasswordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  MyButton(
                    onTap: _isLoading ? () {} : () => _submitForm(context),
                    buttonText: 'Change Password',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
