import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/screens/authentication/sign_up_screen.dart';
import 'package:yaanyo/state_management/auth_state_manager.dart';
import 'package:yaanyo/utilities/form_validator.dart';
import 'package:yaanyo/widgets/error_message_alert.dart';

import '../../constants.dart';

class SignInScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;
    final authStateProvider = watch(authStateManager);
    final isLoading = authStateProvider.isLoading;
    final error = authStateProvider.error;
    final setEmail = authStateProvider.setEmail;
    final setPassword = authStateProvider.setPassword;
    final signIn = authStateProvider.signIn;

    return Scaffold(
      backgroundColor: Colors.blue[500],
      body: SafeArea(
        child: Stack(
          children: [
            ErrorMessageAlert(errorMessage: error),
            Center(
              child: Container(
                height: size.height * 0.55,
                width: size.width * 0.8,
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: size.height * 0.04),
                      TextFormField(
                        //todo validate email format using RegExp
                        validator: (input) =>
                            FormValidator().authEmailField(input),
                        textInputAction: TextInputAction.next,
                        decoration: kTextFormInputDecoration.copyWith(
                          hintText: 'Email',
                        ),
                        onChanged: (input) => setEmail(input),
                      ),
                      SizedBox(height: size.height * 0.01),
                      TextFormField(
                        obscureText: true,
                        validator: (input) =>
                            FormValidator().authPasswordField(input),
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (value) => signIn(context, _formKey),
                        decoration: kTextFormInputDecoration.copyWith(
                            hintText: 'Password'),
                        onChanged: (input) => setPassword(input),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: FlatButton(
                          onPressed: () => signIn(context, _formKey),
                          child: isLoading ?? false
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                )
                              : Text(
                                  'Sign In',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ));
                        },
                        child: Text(
                          'No account? Sign Up Here!',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
