import 'package:flutter/material.dart';
import 'package:yaanyo/services/auth_service.dart';

import '../../constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _email, _password;
  String _error = '';
  bool _isLoading = false;

  Future _signUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      dynamic result =
          await _authService.signUpWithEmailAndPassword(_email, _password);

      if (result == null) {
        setState(() {
          _isLoading = false;
          _error = 'Invalid Email or Password';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue[500],
      body: Center(
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Sign Up',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(height: size.height * 0.02),
                Column(
                  children: [
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? 'Email can not be empty' : null,
                      textInputAction: TextInputAction.next,
                      decoration:
                          kTextFormInputDecoration.copyWith(hintText: 'Email'),
                      onChanged: (input) {
                        setState(() {
                          _email = input;
                        });
                      },
                    ),
                    SizedBox(height: size.height * 0.008),
                    TextFormField(
                      obscureText: true,
                      validator: (value) => value.length < 6
                          ? 'Passwords be 6+ characters long'
                          : null,
                      textInputAction: TextInputAction.go,
                      decoration: kTextFormInputDecoration.copyWith(
                          hintText: 'Password'),
                      onChanged: (input) {
                        setState(() {
                          _password = input;
                        });
                      },
                    ),
                    SizedBox(height: size.height * 0.008),
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
                Text(
                  _error,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.red,
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
      ),
    );
  }
}
