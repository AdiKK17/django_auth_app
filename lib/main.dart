import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'auth_page.dart';
import 'home_page.dart';
import 'auth_provider.dart';
import 'otp_verification_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: Auth())],
      child: MaterialApp(
        home: AuthenticationPage(),
      ),
    );
  }
}
