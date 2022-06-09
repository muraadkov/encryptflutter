// @dart=2.9
import 'dart:io';

import 'package:aes_crypt/aes_crypt.dart';
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
  AesCrypt crypt = AesCrypt();
  crypt.setOverwriteMode(AesCryptOwMode.on);
  crypt.setPassword('aloteq');
  String encFilepath;
  try {
    Stopwatch stopwatch = new Stopwatch()..start();
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result?.files.single != null) {
      String filePath = result?.files.first.path;
      if (filePath != null) {
        encFilepath = crypt.encryptFileSync(filePath);
      }
    }
    print('grg');
    return 'The encryption has been completed successfully in time ${stopwatch.elapsed} in path ${encFilepath} with platform ${Platform.operatingSystem}';
  } catch (e) {
    return 'ERROR ${e.toString()}';
  }
}
