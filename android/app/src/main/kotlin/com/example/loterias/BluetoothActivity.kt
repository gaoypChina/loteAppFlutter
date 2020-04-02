package com.example.loterias

import android.graphics.Bitmap
import android.graphics.Canvas
import android.util.Base64
import android.util.Log
import androidmads.library.qrgenearator.QRGContents
import androidmads.library.qrgenearator.QRGEncoder
import androidx.annotation.NonNull
import com.izettle.html2bitmap.Html2Bitmap
import com.izettle.html2bitmap.content.WebViewContent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Dispatchers.IO
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import java.io.ByteArrayOutputStream

class BluetoothActivity : FlutterActivity(){

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "flutter.bluetooh.stream").setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(args: Any, events: EventChannel.EventSink) {
                        Log.w("channelListen", "adding bluetooth listener")
                        events.success("Successs")
                    }

                    override fun onCancel(args: Any) {
                        Log.w("channelListenCancel", "cancelling listener")
                    }
                }
        )
    }
}