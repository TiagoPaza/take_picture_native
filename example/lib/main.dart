import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:take_picture_native/take_picture_native.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PictureDataModel? _pictureDataModel;

  @override
  void initState() {
    _pictureDataModel = PictureDataModel();
    _pictureDataModel!.inputClickState.add([]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("TAKE PICTURE NATIVE"),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<List<String>>(
                  stream: _pictureDataModel!.outputResult,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(20.0),
                      child: snapshot.hasData
                          ? snapshot.data!.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.file(
                          File(snapshot.data![0]),
                          fit: BoxFit.contain,
                        ),
                      )
                          : const SizedBox.shrink()
                          : const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                  child: Text(
                    "CLICK",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () {
                  TakePictureNative.openCamera.then(
                        (List<String> data) {
                      _pictureDataModel!.inputClickState.add(data);
                    },
                    onError: (e) {
                      _pictureDataModel!.inputClickState.add([]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PictureDataModel {
  final StreamController<List<String>> _streamController =
<<<<<<< HEAD
  StreamController<List<String>>.broadcast();
=======
      StreamController<List<String>>.broadcast();
>>>>>>> d28b9ddda6fbd460136d0c112b3d04538d9d3333

  Sink<List<String>> get inputClickState => _streamController;

  Stream<List<String>> get outputResult =>
      _streamController.stream.map((data) => data);

  dispose() => _streamController.close();
}
