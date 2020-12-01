import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:yaanyo/services/auth_service.dart';
import 'package:yaanyo/utilities/form_validator.dart';
import 'package:yaanyo/widgets/error_message_alert.dart';

import '../../constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email, _password, _name, _error;
  bool _isLoading = false;

  void _signUp() {
    setState(() => _error = null);
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      context
          .read(authServiceProvider)
          .signUpWithEmailAndPassword(
              name: _name, email: _email, password: _password)
          .then((value) {
        //todo fix app is stuck on loading after successful sign up
        if (value == null) {
          Navigator.pop(context);
        } else {
          setState(() {
            _isLoading = false;
            _error = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue[500],
      body: SafeArea(
        child: Stack(
          children: [
            ErrorMessageAlert(errorMessage: _error),
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
                            onChanged: (input) {
                              setState(() {
                                _name = input;
                              });
                            },
                          ),
                          SizedBox(height: size.height * 0.008),
                          TextFormField(
                            //todo validate email format using RegExp
                            validator: (input) =>
                                FormValidator().authEmailField(input),
                            textInputAction: TextInputAction.next,
                            decoration: kTextFormInputDecoration.copyWith(
                                hintText: 'Email'),
                            onChanged: (input) {
                              setState(() {
                                _email = input;
                              });
                            },
                          ),
                          SizedBox(height: size.height * 0.008),
                          TextFormField(
                            obscureText: true,
                            validator: (input) =>
                                FormValidator().authPasswordField(input),
                            textInputAction: TextInputAction.go,
                            onFieldSubmitted: (value) => _signUp(),
                            decoration: kTextFormInputDecoration.copyWith(
                                hintText: 'Password'),
                            onChanged: (input) {
                              setState(() {
                                _password = input;
                              });
                            },
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
                      child: FlatButton(
                        onPressed: () {
                          _signUp();
                        },
                        child: _isLoading
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back to Sign In',
                          style: Theme.of(context).textTheme.bodyText2),
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
