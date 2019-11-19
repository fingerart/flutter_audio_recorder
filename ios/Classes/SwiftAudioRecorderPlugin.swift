import Flutter
import UIKit
import AVFoundation

public class SwiftAudioRecorderPlugin: NSObject, FlutterPlugin {
    
    var recorder: AVAudioRecorder?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "io.chengguo/audio_recorder", binaryMessenger: registrar.messenger())
        let instance = SwiftAudioRecorderPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "isRecording" {
            result(isRecording())
        }else if call.method == "startRecord" {
            do {
                let path = try startRecord(arguments: call.arguments)
                result(path)
            } catch let error {
                NSLog(error.localizedDescription)
                result(FlutterError(code: "OPTIONS_ERROR", message: error.localizedDescription, details: ""))
            }
        }else if call.method == "stopRecord" {
            stopRecord()
            result(0)
        }else if call.method == "getDB" {
            result(0.0)
        }else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    func isRecording() -> Bool {
        if let recorder = self.recorder {
            return recorder.isRecording
        }else {
            return false
        }
    }
    
    func startRecord(arguments: Any?) throws -> String {
        if self.isRecording() {
            self.stopRecord()
        }
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryRecord)
            try session.setActive(true)
        }
        let recordSetting: [String: Any] = [
            AVSampleRateKey: NSNumber(value: 16000),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 2),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.medium.rawValue)//录音质量
        ]
        let args = arguments as? [String: Any]
        var file_path: String
        if let audioPath = args?["audioPath"] as? String {
            file_path = audioPath
        }else {
            let filename = "\(Int(Date().timeIntervalSince1970)).wav"
            let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            file_path = "\(dir ?? "")/\(filename)"
        }
        let uri = URL(fileURLWithPath: file_path)
        do {
            try recorder = AVAudioRecorder(url: uri, settings: recordSetting)
        }
        recorder!.prepareToRecord()
        recorder!.record()
        return file_path
    }
    
    func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                recorder.stop()
            }
            self.recorder = nil
        }
    }
}
