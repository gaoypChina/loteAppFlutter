package com.example.loterias

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.os.Build
import android.util.Base64
import android.util.Log
import androidmads.library.qrgenearator.QRGContents
import androidmads.library.qrgenearator.QRGEncoder
import androidx.annotation.NonNull
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.izettle.html2bitmap.Html2Bitmap
import com.izettle.html2bitmap.content.WebViewContent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Dispatchers.IO
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import java.io.ByteArrayOutputStream

class MainActivity: FlutterActivity() {
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        GeneratedPluginRegistrant.registerWith(flutterEngine);
//    }

    var dataNotification : HashMap<String, Any>? = null;
    private val CHANNEL = "flutter.loterias";
    lateinit var sink:EventSink;
    lateinit var bluetoothManager : BluetoothManager;
    lateinit var bluetoothManagerConnection : BluetoothManager;

//    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
//        super.onCreate(savedInstanceState, persistentState)
//        GeneratedPluginRegistrant.registerWith(this);
//    }

    fun getIntentData(intent: Intent){
        val data = intent.getSerializableExtra("notificacion")
        if(data != null)
            dataNotification = data as HashMap<String, Any>
        else
            dataNotification = null

        Log.e("AndroidNativeCode", "configureFlutterEngine onCreate intentData: " + data);
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        getIntentData(intent)


        //https://flutter.dev/docs/get-started/flutter-for/android-devs#how-do-i-handle-incoming-intents-from-external-applications-in-flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            // Note: this method is invoked on the main thread.
            // TODO

            methods(call, result)

        }


        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "flutter.bluetooh.stream").setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(args: Any, events: EventSink) {
                        Log.w("channelListen", "adding listener: " + args.toString())

                        bluetoothManager = BluetoothManager(this@MainActivity, events)
                        sink = events;
                        bluetoothManager.startScan()
                    }

                    override fun onCancel(args: Any?) {
                        Log.w("channelListenCancel", "cancelling listener")
                        bluetoothManager.stopScan()
                    }
                }
        )

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "flutter.bluetooh.connect").setStreamHandler(
                object : EventChannel.StreamHandler {

                    override fun onListen(args: Any, events: EventSink) {
                        Log.w("channelListen", "adding listener")
                        bluetoothManagerConnection = BluetoothManager(this@MainActivity, events)
                        bluetoothManagerConnection.connect(args as String)
                    }

                    override fun onCancel(args: Any?) {
                        Log.w("channelListenCancel", "cancelling listener")
                        bluetoothManagerConnection.disconnect()
                    }
                }
        )
    }



    override fun onDestroy() {
        super.onDestroy()

        // Don't forget to unregister the ACTION_FOUND receiver.

    }

    fun methods(call:MethodCall, result:MethodChannel.Result ){
        val args = call.arguments<Map<String, Any>>()
        when(call.method){
            "requestPermissions" -> requestPermission(result)
            "share" -> HmltToBitmapAndSendSMSWhatsapp(call, result)
            "printText" -> printText(call, result)
            "turnOnBluetooth" -> turnOnBluetooth(result)
            "quickPrinter" -> quickPrinter(result)
            "initChannelNotification" -> createNotificationChannel(call, result)
            "showNotification" -> showNotification(call, result)
        }
    }

    fun requestPermission(result:MethodChannel.Result){
        Utils.comprobarPermisos(this)
        result.success(true)
    }

    fun quickPrinter(result:MethodChannel.Result){
        val textToPrint:String = "<BIG>Text title<BR>testing <BIG> BIG<BR><BR><QR>12345678<BR><BR>"
        val intent: Intent = Intent("pe.diegoveloper.printing")
        intent.setType("text/plain")
        intent.putExtra(android.content.Intent.EXTRA_TEXT, textToPrint)
        startActivity(intent)
        result.success(true)
    }

    fun turnOnBluetooth(result:MethodChannel.Result){
        BluetoothManager.turnOnBluetoothFromFlutter(this@MainActivity, result)
    }

    fun HmltToBitmapAndSendSMSWhatsapp(call:MethodCall, result:MethodChannel.Result ){
        //IO, Main, Default

        CoroutineScope(IO).launch{
            //Create ticket image

            val bitmapHtml =  async {htmlToBitmap(call.argument<String>("html")) }.await() ;
            val bitmapQr = generateQr(call.argument<String>("codigoQr"));
            val bitmap = combinarBitmap(bitmapHtml, bitmapQr);
            //val base64 = bitmapToBase64(bitmap!!)

            SendTicket.send(this@MainActivity, bitmap, call.argument<String>("sms_o_whatsapp") as Boolean)
            CoroutineScope(Dispatchers.Main).launch {
                result.success("se hizo")
                Log.e("Advertencia", "Despues de resultado")
            }
        }
    }

    fun printText(call: MethodCall, result: MethodChannel.Result){
        val args = call.arguments<Map<String, Any>>()
        val map : Map<Int, Any> = args["data"] as Map<Int, Any>
        for (i in 0 until map.size){

            val m : Map<String, Any> = map[i] as Map<String, Any>
            when(m["cmd"]){
                "PRINT" -> bluetoothManagerConnection.POS_S_TextOut(m["text"] as String, 0, m["nWidthTimes"] as Int, 1, 0, 0x00)
                "ALIGN" -> bluetoothManagerConnection.POS_S_Align(m["text"] as Int)
                "QR" -> bluetoothManagerConnection.POS_S_SetQRcode(m["text"] as String, 8, 0, 3)
                "prueba" -> bluetoothManagerConnection.prueba(m["text"] as String)
                "h1" -> bluetoothManagerConnection.h1(m["text"] as String)
                "h2" -> bluetoothManagerConnection.h2(m["text"] as String)
                "p" -> bluetoothManagerConnection.p(m["text"] as String)
                "left" -> bluetoothManagerConnection.left()
                "right" -> bluetoothManagerConnection.right()
                "center" -> bluetoothManagerConnection.center()
                "qr" -> bluetoothManagerConnection.qr(m["text"] as String)
            }
        }
        CoroutineScope(Dispatchers.Main).launch {
            result.success(true)
        }
    }

    fun combinarBitmap(bitmap1: Bitmap?, bitmap2: Bitmap?): Bitmap? {

        val bmOverlay = Bitmap.createBitmap(bitmap1!!.width, bitmap1.height, bitmap1.config)
        val canvas = Canvas(bmOverlay)
        canvas.drawBitmap(bitmap1, 0f, 0f, null)
        canvas.drawBitmap(bitmap2, 125f, bitmap1.height - 150.toFloat(), null)
        return bmOverlay
    }

    fun bitmapToBase64(bitmap: Bitmap): String? {
        val byteArrayOutputStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
        val byteArray = byteArrayOutputStream.toByteArray()
        return Base64.encodeToString(byteArray, Base64.DEFAULT)
    }


    suspend fun htmlToBitmap(html: String ?) : Bitmap?{
        val bitmap = Html2Bitmap.Builder().setContext(this@MainActivity).setContent(WebViewContent.html(html)).setBitmapWidth(400).build().bitmap
        return bitmap;
    }

    fun generateQr( codigoQr: String?) : Bitmap {
        val qrgEncoder = QRGEncoder(codigoQr, null, QRGContents.Type.TEXT, 150)
        return qrgEncoder.encodeAsBitmap();
    }

    private fun createNotificationChannel(call:MethodCall, result:MethodChannel.Result) {
        try {
            // Create the NotificationChannel, but only on API 26+ because
            // the NotificationChannel class is new and not in the support library
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val name = getString(R.string.channel_name)
                val descriptionText = getString(R.string.channel_description)
                val importance = NotificationManager.IMPORTANCE_DEFAULT
                val channel = NotificationChannel("com.example.loterias", name, importance).apply {
                    description = descriptionText
                }
                // Register the channel with the system
                val notificationManager: NotificationManager =
                        getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                notificationManager.createNotificationChannel(channel)
            }
            result.success("mostrando notificacion")
        }catch (e:Exception){
            result.error("errorInitChannelNotification",e.message, e.message);
        }

    }

    fun showNotification(call:MethodCall, result:MethodChannel.Result ){
        val title:String? = call.argument<String>("title")
        val subtitle:String? = call.argument<String>("subtitle")
        val content:String? = call.argument<String>("content")
        val route:String? = call.argument<String>("route")
        try {
            val notificacion = HashMap<String, Any>()
            notificacion["titulo"] = title!!;
            notificacion["subtitulo"] = subtitle!!;
            notificacion["contenido"] = content!!;
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            }
            intent.action = Intent.ACTION_RUN
            intent.putExtra("notificacion", notificacion)
//            intent.putExtra("route", route)
            Log.e("showNotification", "route: " + route);
            val pendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, intent, 0)
            var builder = NotificationCompat.Builder(this, "com.example.loterias")
                    .setSmallIcon(R.drawable.ic_loteria)
                    .setContentTitle(title)
                    .setContentText(content)
                    .setContentIntent(pendingIntent)
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                    .setAutoCancel(true)


            with(NotificationManagerCompat.from(this)) {
                // notificationId is a unique int for each notification that you must define
                notify(123, builder.build())
            }
            result.success("mostrando notificacion")
        }catch (e:Exception){
            result.error("errorNotification",e.message, e.message);
        }

    }
}
