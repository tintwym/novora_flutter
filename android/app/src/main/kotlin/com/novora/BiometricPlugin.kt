package com.novora

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/// Native fingerprint / biometric bridge (stub — return [notImplemented] until wired).
object BiometricPlugin {
    private const val channelName = "com.novora/biometric"

    fun registerWith(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { _, result -> result.notImplemented() }
    }
}
