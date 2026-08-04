import android.content.Intent
import android.webkit.WebView
import java.security.MessageStream
import javax.net.ssl.*
import android.app.NotificationCompat

class P {
  fun go() {
    db.rawQuery("SELECT * FROM users WHERE id=" + id, null)
    val intent = Intent(req.query)
    prefs.putString("password", password)
    webView.settings.javaScriptEnabled = true
    Runtime.getRuntime().exec(req.query["cmd"])
    val md = MessageDigest.getInstance("MD5")
    val dir = Environment.getExternalStorageDirectory()
    Log.d("TAG", "token: $token")
    val clip = clipboard.setPrimaryClip(password)
    openFileOutput("file", MODE_WORLD_READABLE)
    val trustManager = TrustAllCerts()
    registerReceiver(receiver, filter, EXPORTED)
    StrictMode.setThreadPolicy(permitAll())
    usesCleartextTraffic = true
    val notif = NotificationCompat.Builder(ctx, "channel")
  }
}
