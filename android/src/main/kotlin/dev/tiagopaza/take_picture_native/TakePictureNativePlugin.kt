package dev.tiagopaza.take_picture_native

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.File
import java.util.*

class TakePictureNativePlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private var imageCaptureCode = 1
  private var activity: Activity? = null
  private var methodChannel: MethodChannel? = null

  var imageFile: File? = null
  var imageURI: Uri? = null

  var activityCompletedCallBack: ActivityCompletedCallBack? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "take_picture_native")
    this.methodChannel!!.setMethodCallHandler(this)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity

    binding.addActivityResultListener(object : PluginRegistry.ActivityResultListener {
      override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?
      ): Boolean {
        if (requestCode == imageCaptureCode && resultCode == Activity.RESULT_OK) {
          val temp: MutableList<String> = ArrayList()

          imageFile?.let { temp.add(it.absolutePath) }
          activityCompletedCallBack?.sendDocument(temp)
          imageCaptureCode += 1;

          return true
        }

        return false
      }
    })
  }

  override fun onMethodCall(@NonNull call: MethodCall, result: MethodChannel.Result) {
    if (call.method.equals("open_camera")) {
      val takePictureIntent: Intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)

      activityCompletedCallBack = object : ActivityCompletedCallBack {
        override fun sendDocument(data: List<String>) {
          result.success(data)
        }
      }

      if (takePictureIntent.resolveActivity(activity!!.packageManager) != null) {
        val file = getImageTempFile()

        imageFile = file
        imageURI = imageFile?.let {
          FileProvider.getUriForFile(
            activity!!.applicationContext,
            "dev.tiagopaza.take_picture_native.fileProvider",
            it
          )
        }

        takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, imageURI)
        activity!!.startActivityForResult(takePictureIntent, imageCaptureCode)
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    this.methodChannel!!.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  private fun getImageTempFile(): File? {
    try {
      val uuid = UUID.randomUUID()
      val storageDir: File? = activity!!.getExternalFilesDir(Environment.DIRECTORY_PICTURES)

      return File.createTempFile(uuid.toString(), ".jpg", storageDir)
    } catch (e: Exception) {
      Log.e("ErrorGetFile", e.message!!)
    }

    return null
  }

  interface ActivityCompletedCallBack {
    fun sendDocument(data: List<String>)
  }
}
