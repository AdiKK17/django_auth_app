import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'auth_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Authentication completed",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              onPressed: () => Provider.of<Auth>(context).logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
