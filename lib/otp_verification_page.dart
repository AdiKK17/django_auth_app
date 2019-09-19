import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'auth_provider.dart';

class OtpVerificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OtpVerificationPage();
  }
}

class _OtpVerificationPage extends State<OtpVerificationPage> {
  int _VerifiedOTP;
  bool _isloading = false;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget _buildOTPTextField() {
    return TextFormField(
      maxLength: 6,
      decoration: InputDecoration(
        counterText: "",
          labelText: 'Enter OTP', filled: true, fillColor: Colors.grey),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter the right OTP';
        }
      },
      onSaved: (String value) {
        _VerifiedOTP = int.parse(value);
      },
    );
  }

  void _submitForm() async {

    setState(() {
      _isloading = true;
    });

    if(!_formkey.currentState.validate()){
      return;
    }

    _formkey.currentState.save();
     await Provider.of<Auth>(context).verifyWithOTP(context,_VerifiedOTP);

     setState(() {
       _isloading = false;
     });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP-Verification"),
      ),
      body: Container(
        child: Form(key: _formkey, child: Container(
          height: 300,
          width: double.infinity,
          color: Colors.deepOrangeAccent,
          margin: EdgeInsets.only(top: 150, left: 10, right: 10),
          child: Card(
            elevation: 10,
            child: _isloading ? CircularProgressIndicator() : Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 250,
                  child: _buildOTPTextField(),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () async {await Provider.of<Auth>(context).resendOTP();},
                      child: Text("Resend OTP"),
                    ),
                    RaisedButton(
                      onPressed: () => _submitForm(),
                      child: Text("Verify"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        ),
      ),);
  }
}
