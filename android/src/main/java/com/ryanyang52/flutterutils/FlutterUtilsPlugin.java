package com.ryanyang52.flutterutils;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.content.Context;
import android.content.ContextWrapper;
import android.view.WindowManager;
import android.util.DisplayMetrics;

import java.util.HashMap;
import java.util.Map;

public class FlutterUtilsPlugin implements MethodCallHandler{
    private static final String CHANNELNAME = "plugins.ryanyang52.flutterutils/display";

    public static void registerWith(Registrar registrar) {
        final MethodChannel methodChannel =
            new MethodChannel(registrar.messenger(), CHANNELNAME);
        final FlutterUtilsPlugin instance = new FlutterUtilsPlugin(registrar);
        methodChannel.setMethodCallHandler(instance);
    }

    FlutterUtilsPlugin(Registrar registrar){
        this.registrar = registrar;
    }    
    
    private final Registrar registrar;    

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getDisplayMetrics")) {
            DisplayMetrics dm = getDisplayMetrics();
            if(dm != null){
              Map<String, Object> metrics = new HashMap<>();
              metrics.put("density", dm.density);
              metrics.put("densityDpi", dm.densityDpi);
              metrics.put("width", dm.widthPixels);
              metrics.put("height", dm.heightPixels);
              metrics.put("scaledDensity", dm.scaledDensity);
              metrics.put("xdpi", dm.xdpi);
              metrics.put("ydpi", dm.ydpi);
              result.success(metrics);
            } else {
              result.error("UNAVAILABLE", "Display Metrics Not Available", null);
            }
        }else if(call.method.equals("getBatteryLevel")){
            int batteryLevel = 66;
            result.success(batteryLevel);
        }        
        else {
            result.notImplemented();
        }
    }

    // Request the DisplayMetrics
    private DisplayMetrics getDisplayMetrics() {
        Context context = registrar.context();
        WindowManager windowManager = (WindowManager)context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics dm  = new DisplayMetrics();
        windowManager.getDefaultDisplay().getMetrics(dm);
        return dm;
    }
}