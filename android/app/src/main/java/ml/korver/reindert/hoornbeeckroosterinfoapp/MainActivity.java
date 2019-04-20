package ml.korver.reindert.hoornbeeckroosterinfoapp;

import android.os.Bundle;

import java.io.IOException;
import java.io.InputStream;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    InputStream stream = null;
    try {
      stream = getAssets().open("bootup2.gif");
    } catch (IOException e) {
      e.printStackTrace();
    }
    GifImageView view = new GifImageView(this, stream);
//    setContentView(view, android.R.intro);
  }
}
