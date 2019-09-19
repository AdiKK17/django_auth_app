import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './auth_provider.dart';
import './http_exception.dart';
import 'otp_verification_page.dart';

enum AuthMode { Login, SignUp }

class AuthenticationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthenticationPage();
  }
}

class _AuthenticationPage extends State<AuthenticationPage> {
  var _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();

  final Map<String, dynamic> _formData = {
    "email": null,
    "password": null,
    "username": null,
  };

//  DecorationImage _buildBackGroundImage() {
//    return DecorationImage(
//        fit: BoxFit.cover, image: AssetImage("assets/authImage.jpg"));
//  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-Mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'UserName', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['username'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Passwords do not match.';
        }
      },
    );
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
        color: Colors.black87,
        child: Text(
          _authMode == AuthMode.Login ? "LOGIN" : "SIGNUP",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          _submitForm();
        });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("An error Occured!"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Okay"),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });


      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context,listen: false).login(context,_formData["email"], _formData["password"]);
//        await Provider.of<Auth>(context, listen: false)
//            .login(_formData["email"], _formData["password"]);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(context,_formData["username"],_formData["email"], _formData["password"]);
      }

    setState(() {
      _isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
//        decoration: BoxDecoration(
//          image: _buildBackGroundImage(),
//        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 220),
                  alignment: Alignment.center,
                  child: Text(
                    "ReciPedia",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 50),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Container(
                  child: _buildEmailTextField(),
                  width: deviceWidth * 0.85,
                ),
                SizedBox(
                  height: 15,
                ),
                _authMode == AuthMode.SignUp
                    ? Container(
                        child: _buildUsernameTextField(),
                        width: deviceWidth * 0.85,
                      )
                    : Container(),
                SizedBox(height: 10,),
                Container(
                  child: _buildPasswordTextField(),
                  width: deviceWidth * 0.85,
                ),
                SizedBox(
                  height: 10,
                ),
                _authMode == AuthMode.SignUp
                    ? Container(
                        child: _buildPasswordConfirmTextField(),
                        width: deviceWidth * 0.85,
                      )
                    : Container(),
                SizedBox(
                  height: 25,
                ),
                _isLoading == true
                    ? CircularProgressIndicator()
                    : Container(
                        child: _buildSubmitButton(),
                        width: 200,
                      ),
                SizedBox(
                  height: 30,
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      if (_authMode == AuthMode.Login) {
                        _authMode = AuthMode.SignUp;
                      } else {
                        _authMode = AuthMode.Login;
                      }
                    });
                  },
                  child: Text(_authMode == AuthMode.Login
                      ? "Not a user?  SignUp first"
                      : "Login Instead"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
