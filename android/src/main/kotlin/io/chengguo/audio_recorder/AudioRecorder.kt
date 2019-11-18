package io.chengguo.audio_recorder

import android.content.Context
import android.media.MediaRecorder
import com.isvisoft.flutter_screen_recording.letNull
import java.io.File
import java.lang.Double.isInfinite
import kotlin.math.log10

class AudioRecorder {

    var isRecording: Boolean = false
    private var mediaRecorder: MediaRecorder? = null

    fun startRecord(context: Context, _audioPath: String?): String {
        val audioPath: String = _audioPath.letNull { generateAudioPath(context) }
        release()
        mediaRecorder = MediaRecorder()
        mediaRecorder!!.setAudioSource(MediaRecorder.AudioSource.MIC)
        mediaRecorder!!.setOutputFormat(MediaRecorder.OutputFormat.DEFAULT)
        mediaRecorder!!.setAudioEncoder(MediaRecorder.AudioEncoder.DEFAULT)
        mediaRecorder!!.setOutputFile(audioPath)
        mediaRecorder!!.prepare()
        mediaRecorder!!.start()
        isRecording = true
        return audioPath
    }

    fun stopRecord() {
        try {
            mediaRecorder?.stop()
            release()
        } finally {
            isRecording = false
        }
    }

    fun getDB(): Double {
        val maxAmplitude = mediaRecorder?.maxAmplitude.letNull { 0 }
        // Calculate db based on the following article.
        // https://stackoverflow.com/questions/10655703/what-does-androids-getmaxamplitude-function-for-the-mediarecorder-actually-gi
        //
        val refPressure = 51805.5336
        val p = maxAmplitude / refPressure
        val p0 = 0.0002

        var db = 20.0 * log10(p / p0)

        // if the microphone is off we get 0 for the amplitude which causes
        // db to be infinite.
        if (isInfinite(db)) db = 0.0
        return db
    }

    private fun release() {
        if (mediaRecorder != null) {
            mediaRecorder!!.reset()
            mediaRecorder!!.release()
            mediaRecorder = null
        }
    }

    private fun generateAudioPath(context: Context): String {
        val path = "${context.getExternalFilesDir(null)?.absolutePath}${File.separator}${System.currentTimeMillis()}.mp3"

        if (File(path).exists()) {
            return generateAudioPath(context)
        }

        return path
    }
}