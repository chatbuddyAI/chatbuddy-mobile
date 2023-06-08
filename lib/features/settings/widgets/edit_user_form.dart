// ignore_for_file: use_build_context_synchronously

import 'package:chat_buddy/common/utils/app_utility.dart';
import 'package:chat_buddy/exceptions/http_exception.dart';
import 'package:chat_buddy/providers/auth_provider.dart';
import 'package:chat_buddy/widgets/loading.dart';
import 'package:chat_buddy/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/my_text_form_field.dart';

class EditUserForm extends StatefulWidget {
  final String name;
  const EditUserForm({super.key, required this.name});

  @override
  State<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Perform password change logic here
      String fullName = _fullNameController.text.trim();

      if (fullName == widget.name) {
        return;
      }

      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<AuthProvider>(context, listen: false)
            .updateMe(fullName);
        AppUtility.showSuccessDialog(
            context: context, message: 'Name Updated successfully!');
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
    _fullNameController.text = widget.name;
    return WillPopScope(
      onWillPop: () async {
        return !_isLoading;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isLoading)
            const SizedBox(height: 70, width: 70, child: Loading()),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8.0),
                  MyTextFormField(
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    label: 'Full Name',
                    hintText: 'John Doe',
                    obscureText: false,
                    isEnabled: !_isLoading,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your full name';
                      }
                      // Custom validation logic, if needed
                      if (!AppUtility.isFullNameValid(value)) {
                        return 'Please enter a valid full name';
                      }

                      return null; // Return null to indicate no error
                    },
                  ),
                  const SizedBox(height: 12.0),
                  MyButton(
                    onTap: _isLoading ? () {} : () => _submitForm(context),
                    buttonText: 'Update',
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
