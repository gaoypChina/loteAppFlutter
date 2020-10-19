package com.example.loterias

import android.util.Log
import com.github.nkzawa.engineio.client.transports.WebSocket
import com.github.nkzawa.socketio.client.IO
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import com.github.nkzawa.socketio.client.Socket;
import org.json.JSONObject


class MySocket {
    companion object{
        lateinit var webSocket:Socket;
        fun connect(url:String, room:String){
            val opts = IO.Options();


            val jwt = Jwts.builder().claim("id", 836).claim("username", "john.doe")
                    .signWith(SignatureAlgorithm.HS256, "quierocomerpopola".toByteArray())
                    .compact()

//            opts.path = "/path/to/ws"
            opts.query = "auth_token=$jwt&room=$room"
            opts.transports = arrayOf(WebSocket.NAME)
            webSocket = IO.socket(url, opts)
            webSocket.connect()
                    .on(Socket.EVENT_CONNECT) {
                        // Do your stuff here
                        Log.d("MySocketKotlin", "Se conectoooooooooooooooo")
                    }
                    .on("notification:App\\Events\\NotificationEvent") { parameters -> // do something on recieving a 'foo' event
                        // 'parameters' is an Array of all parameters you sent
                        // Do your stuff here
//                        val jsonString = parameters[0] as String;
                        val map = parameters[0] as JSONObject
                        val notificacion = map.getJSONObject("notification");

//                        Log.d("MySocketKotlin", )
                        Log.d("MySocketKotlin", notificacion.getString("titulo"))
                        val ramdonId = (0..1000).random()
                        MainActivity.showNotificationNative(notificacion.getString("titulo"), notificacion.getString("subtitulo"), notificacion.getString("contenido"), ramdonId)
                    }
                    .on(Socket.EVENT_CONNECT_ERROR){ parameters ->
                        Log.d("MySocketKotlin", "Error: " + parameters[1])
                    }
        }

        fun disconnect(){
            if(webSocket != null)
                webSocket.disconnect();
        }
    }
}