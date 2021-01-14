import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/state_management/auth_state_manager.dart';
import 'package:yaanyo/utilities/form_validator.dart';
import 'package:yaanyo/widgets/error_message_alert.dart';

import '../../constants.dart';

class SignUpScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final authStateProvider = watch(authStateManager);
    final isLoading = authStateProvider.isLoading;
    final error = authStateProvider.error;
    final setName = authStateProvider.setName;
    final setEmail = authStateProvider.setEmail;
    final setPassword = authStateProvider.setPassword;
    final signUp = authStateProvider.signUp;

    return Scaffold(
      backgroundColor: Colors.blue[500],
      body: SafeArea(
        child: Stack(
          children: [
            ErrorMessageAlert(errorMessage: error),
            Center(
              child: Container(
                height: size.height * 0.6,
                width: size.width * 0.8,
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Sign Up',
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(height: size.height * 0.02),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            validator: (input) =>
                                FormValidator().authNameField(input),
                            textInputAction: TextInputAction.next,
                            decoration: kTextFormInputDecoration.copyWith(
                                hintText: 'Name'),
                            onChanged: (input) => setName(input),
                          ),
                          SizedBox(height: size.height * 0.008),
                          TextFormField(
                            //todo validate email format using RegExp
                            validator: (input) =>
                                FormValidator().authEmailField(input),
                            textInputAction: TextInputAction.next,
                            decoration: kTextFormInputDecoration.copyWith(
                                hintText: 'Email'),
                            onChanged: (input) => setEmail(input),
                          ),
                          SizedBox(height: size.height * 0.008),
                          TextFormField(
                            obscureText: true,
                            validator: (input) =>
                                FormValidator().authPasswordField(input),
                            textInputAction: TextInputAction.go,
                            onFieldSubmitted: (value) =>
                                signUp(context, _formKey),
                            decoration: kTextFormInputDecoration.copyWith(
                                hintText: 'Password'),
                            onChanged: (input) => setPassword(input),
                          ),
                          // SizedBox(height: size.height * 0.008),
                          //todo validate matching fields
                          // TextFormField(
                          //   obscureText: true,
                          //   validator: (value) => value.length < 6
                          //       ? 'Password fields must match'
                          //       : null,
                          //   decoration: kTextFormInputDecoration.copyWith(
                          //       hintText: 'Verify Password'),
                          //   onChanged: (input) {
                          //     setState(() {
                          //       _password = input;
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: TextButton(
                        onPressed: () => signUp(context, _formKey),
                        child: isLoading ?? false
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              )
                            : Text(
                                'Sign Up',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Back to Sign In',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
