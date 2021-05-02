package com.example.loterias

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.net.Uri
import android.util.Log
import android.widget.Toast
import java.net.URI

class SendTicket{
    companion object{
        fun send(context: Context, base64Image: Bitmap?, sms: Boolean) {
            val pack = "com.whatsapp"
            val titleImage = "ticket"

            val imageUri: Uri = Utils.toUri(context, base64Image!!, titleImage)!!
            if (sms) {
                val mmsIntent = Intent(Intent.ACTION_SEND)
                mmsIntent.putExtra("sms_body", "Please see the attached image")
                // mmsIntent.setType("vnd.android-dir/mms-sms");
                mmsIntent.putExtra(Intent.EXTRA_STREAM, imageUri)
                mmsIntent.type = "image/*"
                context.startActivity(Intent.createChooser(mmsIntent, "Send"))
            } else {
                val pm = context.packageManager
                try {
                    val info = pm.getPackageInfo(pack, PackageManager.GET_META_DATA)

                    if (!sms) {
                        val waIntent = Intent(Intent.ACTION_SEND)
                        waIntent.type = "image/*"
                        waIntent.setPackage(pack)
                        waIntent.putExtra(Intent.EXTRA_STREAM, imageUri)
                        waIntent.putExtra(Intent.EXTRA_TEXT, pack)
                        context.startActivity(Intent.createChooser(waIntent, "Share with"))
                    } else {

                    }
                } catch (e: Exception) {
                    Log.e("Error on sharing", "$e ")
                    Toast.makeText(context, "App not Installed", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }
}