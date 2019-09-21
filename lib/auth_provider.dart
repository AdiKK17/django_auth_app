import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './http_exception.dart';
import 'otp_verification_page.dart';
import 'home_page.dart';
import 'auth_page.dart';


class Auth with ChangeNotifier {
  String _username;
  String _user_Id;

  String get username {
    return _username;
  }

  String get userId {
    return _user_Id;
  }

  void _showErrorDialog(BuildContext context, String message) {
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

  Future<void> verifyWithOTP(BuildContext context, int enteredOtp) async {
    print("dassh12");
    print(enteredOtp);
    print(_user_Id);
    print("hashhh2323");

    final url = "https://077e8e13.ngrok.io/api/activate/$_user_Id/";

    final response = await http.post(url,
        body: json.encode({"otp": enteredOtp}),
        headers: {'Content-Type': 'application/json'});
    final responseData = json.decode(response.body);
    print(responseData);
    if (responseData["error"] != null) {
      _showErrorDialog(context, responseData["error"]);
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  Future<void> resendOTP() async {
    print(_user_Id);
    print("OTP has been sent to  user $_user_Id");
    final url = "https://077e8e13.ngrok.io/api/resendotp/$_user_Id/";
    final response =  await http.get(url);
    print(json.decode(response.body));
  }

  Future<void> signUp(BuildContext context, String username, String email,
      String password) async {
    const url = "https://077e8e13.ngrok.io/api/signup/";
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          "email": email,
          "username": username,
          "password": password,
          "confirm_password": password
        },
      ),
    );
    final responseData = json.decode(response.body);

    print(responseData);
    if (responseData["email"] != null) {
      _showErrorDialog(context, responseData["email"][0]);
      print("email already exists");
      return;
    }

    if (responseData["username"] != null) {
      _showErrorDialog(context, responseData["username"][0]);
      print("email already exists");
      return;
    }

    _username = responseData["details"];
    _user_Id = responseData["user_id"].toString();
    print(_username);
    print(_user_Id);
    print(responseData);
    print("it is responding");
    notifyListeners();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OtpVerificationPage(),
      ),
    );
  }

  Future<void> login(
      BuildContext context, String username, String password) async {
    print(username);
    print(password);
    const url = "https://077e8e13.ngrok.io/api/login/";
    final response = await http.post(url,
        body: json.encode({"uname_or_em": username, "password": password}),
        headers: {'Content-Type': 'application/json'});
    final responseData = json.decode(response.body);

    if (responseData["error"] != null) {
      _showErrorDialog(context, responseData["error"]);
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthenticationPage()), (Route<dynamic> route) => false);
  }

}
