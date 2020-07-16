package io.chengguo.audio_recorder

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class ChengguoAudioRecorderPlugin(private val registrar: Registrar, channel: MethodChannel) : MethodCallHandler {

    private val permissionHandler: PermissionHandler = PermissionHandler()
    private val audioRecorder = AudioRecorder()

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "io.chengguo/audio_recorder")
            ChengguoAudioRecorderPlugin(registrar, channel)
        }
    }

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            call.method == "isRecording" -> result.success(audioRecorder.isRecording)
            call.method == "startRecord" ->
                permissionHandler.requestPermissions(registrar.activity(), registrar) { errCode: ErrorCode, errorDescription: String ->
                    if (errCode != ErrorCode.OK) {
                        return@requestPermissions result.error(errCode.name, errorDescription, "")
                    }
                    try {
                        val audioPath = call.argument<String>("audioPath")
                        val path = audioRecorder.startRecord(registrar.context(), audioPath)
                        result.success(path)
                    } catch (e: Exception) {
                        result.error(e.message, e.toString(), "")
                    }
                }
            call.method == "stopRecord" ->
                try {
                    audioRecorder.stopRecord()
                    result.success(0)
                } catch (e: Exception) {
                    result.error(ErrorCode.OPTIONS_ERROR.name, e.message, "")
                }
            call.method == "getDB" -> result.success(audioRecorder.getDB())
            else -> result.notImplemented()
        }
    }

}
