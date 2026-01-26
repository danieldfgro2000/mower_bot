package dfg.dan.mower_bot

import android.app.Activity
import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class PlatformSettingsPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var activity: Activity? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "mower_bot/platform_settings")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "openWifiPanel" -> {
        val act = activity
        if (act == null) {
          result.error("no_activity", "No foreground activity", null)
          return
        }

        try {
          val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            Intent(Settings.Panel.ACTION_WIFI)
          } else {
            Intent(Settings.ACTION_WIFI_SETTINGS)
          }
          act.startActivity(intent)
          result.success(null)
        } catch (e: Exception) {
          result.error("failed", e.message, null)
        }
      }
      "openLocationSettings" -> {
        val act = activity
        if (act == null) {
          result.error("no_activity", "No foreground activity", null)
          return
        }

        try {
          val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
          act.startActivity(intent)
          result.success(null)
        } catch (e: Exception) {
          result.error("failed", e.message, null)
        }
      }
      else -> result.notImplemented()
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }
}
