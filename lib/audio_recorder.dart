import 'dart:async';

import 'package:flutter/services.dart';

export 'error_code.dart';

class AudioRecorder {
  static const MethodChannel _channel = const MethodChannel('io.chengguo/audio_recorder');

  static Future<bool> isRecording() => _channel.invokeMethod('isRecording');

  static Future<String> startRecord([String audioPath]) => _channel.invokeMethod('startRecord', {"audioPath": audioPath});

  static Future stopRecord() => _channel.invokeMethod('stopRecord');

  static Future<double> get db => _channel.invokeMethod('getDB');
}
