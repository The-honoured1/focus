package com.ceo3.focus

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.ceo3.focus/blocking"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startStrictBlock" -> {
                    val packages = call.argument<List<String>>("packages")
                    val intent = Intent(this, StrictBlockService::class.java)
                    intent.putExtra("packages", packages?.toTypedArray())
                    startService(intent)
                    result.success(true)
                }
                "stopStrictBlock" -> {
                    stopService(Intent(this, StrictBlockService::class.java))
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
