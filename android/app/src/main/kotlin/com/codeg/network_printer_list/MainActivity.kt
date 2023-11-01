package com.example.kotlin_call_from_flutter

import kotlin.random.Random
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.annotation.NonNull as NonNull1

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull1 flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "example.com/channel"
        ).setMethodCallHandler { call, result ->
            if (call.method == "getRandom") {
                val limit = call.argument("len") ?: 4
                val prefix = call.argument("prefix") ?: ""
                if(limit < 0) {
                    result.error("INVALIDARGS", "String length should not be a negative integer", null)
                }
                else {
                    val rand = ('a'..'z')
                        .shuffled()
                        .take(limit)
                        .joinToString(prefix = prefix, separator = "")
                    result.success(rand)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
