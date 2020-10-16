package com.example.loterias

import android.util.Log
import com.github.nkzawa.engineio.client.transports.WebSocket
import com.github.nkzawa.socketio.client.IO
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import com.github.nkzawa.socketio.client.Socket;


class MySocket {
    companion object{
        fun connect(room:String){
            val opts = IO.Options();


            val jwt = Jwts.builder().claim("id", 836).claim("username", "john.doe")
                    .signWith(SignatureAlgorithm.HS256, "quierocomerpopola".toByteArray())
                    .compact()

//            opts.path = "/path/to/ws"
            opts.query = "auth_token=$jwt&room=$room"
            opts.transports = arrayOf(WebSocket.NAME)
            val webSocket = IO.socket("http://loteriasdo.gq:3000", opts)
            webSocket.connect()
                    .on(Socket.EVENT_CONNECT) {
                        // Do your stuff here
                        Log.d("MySocketKotlin", "Se conectoooooooooooooooo")
                    }
                    .on("notification:App\\Events\\NotificationEvent") { parameters -> // do something on recieving a 'foo' event
                        // 'parameters' is an Array of all parameters you sent
                        // Do your stuff here
                        Log.d("MySocketKotlin", parameters[0].toString())
                    }
                    .on(Socket.EVENT_CONNECT_ERROR){ parameters ->
                        Log.d("MySocketKotlin", "Error: " + parameters[1])
                    }
        }
    }
}