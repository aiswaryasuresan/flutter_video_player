package com.example.flutter_video_player
import android.os.Bundle
import android.view.WindowManager.LayoutParams.FLAG_SECURE
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.setFlags(FLAG_SECURE, FLAG_SECURE)
    }
}
