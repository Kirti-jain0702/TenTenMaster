package com.tentendelivery.customer

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.res.Configuration
import java.util.*
import android.os.Bundle
import android.util.Log
import android.os.Build
import android.view.ViewTreeObserver
import android.view.WindowManager
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

/*   fun changeLocale() {
        val locale = Locale("it")
        Locale.setDefault(locale)
        val config = Configuration()
        config.locale = locale
        baseContext.resources.updateConfiguration(config,
                baseContext.resources.displayMetrics)
    }*/

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    /*    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "localeChange").setMethodCallHandler { call, result ->
            if (call.method == "locale") {
              //val lang  = call.argument<String>("lang")
                changeLocale()//lang.toString()
                Log.e("hereInTheCage", "gosla")
            }
        }*/
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}