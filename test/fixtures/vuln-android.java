class MainActivity extends Activity {
  void go() {
    WebView wv = findViewById(R.id.webview);
    wv.setJavaScriptEnabled(true);
    wv.addJavascriptInterface(new JsObject(), "Android");
  }
}
