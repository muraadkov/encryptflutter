// @dart=2.9
import 'dart:io';
import 'dart:typed_data';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = 'Wait for encrypting...';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  String encr = await encryptFile();
                  setState(() {
                    text = encr;
                  });
                },
                child: const Text('start encrypt file')),
            Text(text),
          ],
        ),
      ),
    );
  }
}

Future<String> encryptFile() async {
  FilePickerResult result = await FilePicker.platform.pickFiles();

  if (result != null) {
    final algorithm = AesGcm.with256bits();
    final secretKey = await algorithm.newSecretKey();

    File file2 = File(result.files.first.path);


    // Generate a random 96-bit nonce.
    final nonce = algorithm.newNonce();

    // Encrypt
    Stopwatch stopwatch = new Stopwatch()
      ..start();
    final secretBox = await algorithm.encrypt(
      file2.readAsBytesSync(),
      secretKey: secretKey,
      nonce: nonce,
    );
    print('Ciphertext: ${secretBox.cipherText}');
    print('MAC: ${secretBox.mac}');
    return 'The encryption has been completed successfully in time ${stopwatch
        .elapsed} with platform ${Platform.operatingSystem}';
  }
}
