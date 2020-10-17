package com.loterias.jean2.creta

import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.example.loterias.MainActivity
import com.example.loterias.MySocket
import com.example.loterias.R

class MyService : Service() {

    override fun onBind(intent: Intent): IBinder {
        TODO("Return the communication channel to the service.")
    }

    override fun onCreate() {
        super.onCreate()



    }

    override fun onDestroy() {
        super.onDestroy()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//        try {
        val mContext = getApplicationContext();

        val room = intent?.getStringExtra("room")
        val url = intent?.getStringExtra("url")

        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0)
        val builder = NotificationCompat.Builder(this, "com.example.loterias")
                .setSmallIcon(R.drawable.ic_loteria)
                .setContentTitle("Procesos internos")
                .setContentText("Procesos internos del sistema")
                .setContentIntent(pendingIntent)
//                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
//                    .setAutoCancel(true)
                .build()


        MySocket.connect(url!!, room!!)
        startForeground(1, builder)
//        }catch (e:Exception){
//            Log.e("MyService", "Error: " + e.toString())
//        }
//        return super.onStartCommand(intent, flags, startId);
        return START_NOT_STICKY;
    }
}
