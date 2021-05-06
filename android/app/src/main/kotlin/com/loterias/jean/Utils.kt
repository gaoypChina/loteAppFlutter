package com.loterias.jean

import android.Manifest
import android.app.Activity
import android.app.ActivityManager
import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.net.Uri
import android.provider.MediaStore
import android.util.Base64
import android.util.Log
import androidmads.library.qrgenearator.QRGContents
import androidmads.library.qrgenearator.QRGEncoder
import androidx.core.app.ActivityCompat
import androidx.core.app.ActivityCompat.requestPermissions
import com.izettle.html2bitmap.Html2Bitmap
import com.izettle.html2bitmap.content.WebViewContent
import java.io.ByteArrayOutputStream
import java.io.File

class Utils {

    companion object{
        public fun comprobarPermisos(context : Context) {
            val REQUEST_CODE_ASK_PERMISSION = 111
            val permisosCamara: Int = ActivityCompat.checkSelfPermission(context, Manifest.permission.CAMERA)
            val permisosStorage: Int = ActivityCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE)
            //        int permisosSms = ActivityCompat.checkSelfPermission(mContext, Manifest.permission.SEND_SMS);
//            val permisosLocation: Int = ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
//            val permisosLocationCoarse: Int = ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION)


            //|| permisosSms != PackageManager.PERMISSION_GRANTED
            //, Manifest.permission.SEND_SMS
            if (permisosStorage != PackageManager.PERMISSION_GRANTED || permisosCamara != PackageManager.PERMISSION_GRANTED
//                    || permisosLocation != PackageManager.PERMISSION_GRANTED
//                    || permisosLocationCoarse != PackageManager.PERMISSION_GRANTED
            ) {
                //if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
                requestPermissions(context as Activity,
                        arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE,
                                Manifest.permission.CAMERA
//                                ,
//                                Manifest.permission.ACCESS_FINE_LOCATION,
//                                Manifest.permission.ACCESS_COARSE_LOCATION
                        ), REQUEST_CODE_ASK_PERMISSION)
                //}
            }
        }

        fun combinarBitmap(bitmap1: Bitmap?, bitmap2: Bitmap?): Bitmap? {

            val bmOverlay = Bitmap.createBitmap(bitmap1!!.width, bitmap1.height, bitmap1.config)
            val canvas = Canvas(bmOverlay)
            canvas.drawBitmap(bitmap1, 0f, 0f, null)
            canvas.drawBitmap(bitmap2!!, 125f, bitmap1.height - 150.toFloat(), null)
            return bmOverlay
        }

        fun bitmapToBase64(bitmap: Bitmap): String? {
            val byteArrayOutputStream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
            val byteArray = byteArrayOutputStream.toByteArray()
            return Base64.encodeToString(byteArray, Base64.DEFAULT)
        }


        suspend fun htmlToBitmap(html: String ?, context: Context) : Bitmap?{
            val bitmap = Html2Bitmap.Builder().setContext(context).setContent(WebViewContent.html(html)).setBitmapWidth(400).build().bitmap
            return bitmap;
        }

        fun generateQr( codigoQr: String?) : Bitmap {
            val qrgEncoder = QRGEncoder(codigoQr, null, QRGContents.Type.TEXT, 150)
            return qrgEncoder.encodeAsBitmap();
        }

        fun toUriNew(context: Context, bitmap: Bitmap, title: String?): Uri? {
            val file = File(context.cacheDir,"CUSTOM NAME") //Get Access to a local file.
            file.delete() // Delete the File, just in Case, that there was still another File
            file.createNewFile()
            val fileOutputStream = file.outputStream()
            val byteArrayOutputStream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG,100,byteArrayOutputStream)
            val bytearray = byteArrayOutputStream.toByteArray()
            fileOutputStream.write(bytearray)
            fileOutputStream.flush()
            fileOutputStream.close()
            byteArrayOutputStream.close()

//            val URI = file.toURI()
            return Uri.parse(file.absolutePath);
        }

        fun toUri(context: Context, bitmap: Bitmap, title: String?): Uri? {
            val bytes = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, bytes)
            val path = MediaStore.Images.Media.insertImage(context.contentResolver, bitmap, "img_" + System.currentTimeMillis(), null)
            return Uri.parse(path)
        }

        fun killAppServiceByPackageName(context: Context, packageName: String?) {
            var packageName = packageName
            val packages: List<ApplicationInfo>
            val pm: PackageManager
            pm = context.packageManager
            //get a list of installed apps.
            packages = pm.getInstalledApplications(0)
            if (packageName == null) packageName = "com.example.lotecom.mobile"
            val packageTokill: String = packageName
            val mActivityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            for (packageInfo in packages) {
                Log.d("Utils", "killAppServiceByPackageName: " + packageInfo.packageName)
                if (packageInfo.packageName == packageTokill) {
                    mActivityManager.killBackgroundProcesses(packageInfo.packageName)
                }
            }
        }

    }

}