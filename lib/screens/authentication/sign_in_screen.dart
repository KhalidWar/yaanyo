import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yaanyo/screens/authentication/sign_up_screen.dart';
import 'package:yaanyo/services/auth_service.dart';
import 'package:yaanyo/services/database_service.dart';
import 'package:yaanyo/services/shared_pref_service.dart';

import '../../constants.dart';
import '../home_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  final SharedPrefService _sharedPrefService = SharedPrefService();

  final _formKey = GlobalKey<FormState>();
  QuerySnapshot _userSnapshot;

  String _email, _password;
  String _error = '';
  bool _isLoading = false;

  Future _signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      dynamic result =
          await _authService.signInWithEmailAndPassword(_email, _password);
      if (result == null) {
        setState(() {
          _isLoading = false;
          _error = 'Invalid Email or password';
        });
      } else {
        // await _databaseService.searchUserByEmail(_email).then((value) {
        //   _userSnapshot = value;
        _sharedPrefService.saveUserDetails(userEmail: _email);
        // });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign In',
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(height: size.height * 0.04),
                TextFormField(
                  //todo validate email format using RegExp
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
                SizedBox(height: size.height * 0.01),
                TextFormField(
                  obscureText: true,
                  validator: (value) => value.length < 6
                      ? 'Password must be 6+ characters long'
                      : null,
                  textInputAction: TextInputAction.go,
                  decoration:
                      kTextFormInputDecoration.copyWith(hintText: 'Password'),
                  onChanged: (input) {
                    setState(() {
                      _password = input;
                    });
                  },
                ),
                SizedBox(height: size.height * 0.03),
                Text(_error,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.red,
                        )),
                Container(
                  width: size.width * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.blue[500],
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: FlatButton(
                    onPressed: () {
                      _signIn();
                    },
                    child: _isLoading
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SignUpScreen();
                    }));
                  },
                  child: Text('No account? Sign Up Here!',
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
