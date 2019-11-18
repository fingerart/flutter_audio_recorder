package  io.chengguo.audio_recorder

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import io.flutter.plugin.common.PluginRegistry

typealias ResultCallback = (errorCode: ErrorCode, errorDescription: String) -> Unit

class PermissionHandler : PluginRegistry.RequestPermissionsResultListener {
    private val permissions = arrayOf(
            Manifest.permission.RECORD_AUDIO,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.READ_EXTERNAL_STORAGE
    )
    private var isAddRequestPermissionsResultListener: Boolean = false
    private var callback: ResultCallback? = null

    companion object {
        const val REQUEST_CODE_PERMISSION = 8192
    }

    fun requestPermissions(activity: Activity, registrar: PluginRegistry.Registrar, callback: ResultCallback) {
        if (!hasPermissions(activity, *permissions)) {
            if (!isAddRequestPermissionsResultListener)
                registrar.addRequestPermissionsResultListener(this)
            this.callback = callback
            ActivityCompat.requestPermissions(activity, permissions, REQUEST_CODE_PERMISSION)
        } else {
            callback(ErrorCode.OK, "")
        }
    }

    private fun hasPermissions(context: Context, vararg permissions: String): Boolean {
        permissions.forEach {
            if (ActivityCompat.checkSelfPermission(context, it) != PackageManager.PERMISSION_GRANTED) return false
        }
        return true
    }

    override fun onRequestPermissionsResult(requestId: Int, permissions: Array<String>, grantResults: IntArray): Boolean {
        if (requestId == REQUEST_CODE_PERMISSION && callback != null) {
            val deniedPermissionIndex = grantResults.indexOf(PackageManager.PERMISSION_DENIED)
            if (deniedPermissionIndex < 0) {
                callback!!(ErrorCode.OK, "")
            } else {
                callback!!(ErrorCode.PERMISSION_DENIED, "${permissions[deniedPermissionIndex]} permission not granted")
            }
            callback = null
            return true
        }
        return false
    }
}