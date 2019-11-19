import 'dart:async';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isRecording = false;
  String _audioPath;
  Timer _timer;
  int _tick = 0;
  double _db = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text("${_tick}s  ${_db}db",
                    style: TextStyle(fontSize: 40, color: Colors.blue)),
              ),
              MaterialButton(
                onPressed: _isRecording ? null : () => _startRecord(),
                child: Text("Start"),
                color: Colors.green,
              ),
              MaterialButton(
                onPressed: _isRecording ? () => _stopRecord() : null,
                child: Text("Stop"),
                color: Colors.red,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("    Output audio path:"),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Text(
                      "${_audioPath ?? "Empty"}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _startRecord() async {
    try {
      var path = await AudioRecorder.startRecord();
      debugPrint("path: $path");
      var isRecording = await AudioRecorder.isRecording();
      setState(() {
        _audioPath = path;
        _isRecording = isRecording;
      });
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        double db = await AudioRecorder.db;
        setState(() {
          _tick = timer.tick;
          _db = db.floorToDouble();
        });
      });
    } catch (e) {
      debugPrint("$e");
    }
  }

  _stopRecord() async {
    try {
      await AudioRecorder.stopRecord();
    } catch (e) {
      debugPrint("$e");
    } finally {
      _timer?.cancel();
      var isRecording = await AudioRecorder.isRecording();
      setState(() {
        _audioPath = null;
        _tick = 0;
        _isRecording = isRecording;
      });
    }
  }
}
