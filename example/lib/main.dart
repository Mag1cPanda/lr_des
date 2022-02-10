import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:lr_des/lr_des.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  final _string = "flutter";
  final _key = "taidtaxiexamrest";

  var _encrytString;
  var _decrytString;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    example();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await LrDes.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> example() async {
    _encrytString = await LrDes.encryptToBase64(_string, _key);
    _decrytString = await LrDes.decryptFromBase64(_encrytString, _key);



    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('des example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('string : $_string'),
              Text('key : $_key'),
              Text('encrytString : $_encrytString'),
            ],
          ),
        ),
      ),
    );
  }
}
