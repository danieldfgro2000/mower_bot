package dfg.dan.mower_bot

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.util.concurrent.atomic.AtomicBoolean

class WifiNetworkPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private var appContext: Context? = null
  private var networkCallback: ConnectivityManager.NetworkCallback? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    appContext = binding.applicationContext
    channel = MethodChannel(binding.binaryMessenger, "mower_bot/wifi_network")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    clearNetworkCallback()
    appContext = null
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "bindToWifiNetwork" -> bindToWifiNetwork(result)
      "unbindFromNetwork" -> {
        unbindFromNetwork()
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  private fun bindToWifiNetwork(result: MethodChannel.Result) {
    val context = appContext
    if (context == null) {
      result.error("no_context", "Application context is null", null)
      return
    }

    val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    clearNetworkCallback()

    val request = NetworkRequest.Builder()
      .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
      .build()

    val delivered = AtomicBoolean(false)
    val callback = object : ConnectivityManager.NetworkCallback() {
      override fun onAvailable(network: Network) {
        cm.bindProcessToNetwork(network)
        if (delivered.compareAndSet(false, true)) {
          result.success(true)
        }
      }

      override fun onUnavailable() {
        if (delivered.compareAndSet(false, true)) {
          result.success(false)
        }
      }
    }

    networkCallback = callback
    cm.requestNetwork(request, callback)
  }

  private fun unbindFromNetwork() {
    val context = appContext ?: return
    val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    cm.bindProcessToNetwork(null)
    clearNetworkCallback()
  }

  private fun clearNetworkCallback() {
    val context = appContext ?: return
    val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    val callback = networkCallback
    if (callback != null) {
      try {
        cm.unregisterNetworkCallback(callback)
      } catch (_: Exception) {
        // Best-effort cleanup.
      }
      networkCallback = null
    }
  }
}
