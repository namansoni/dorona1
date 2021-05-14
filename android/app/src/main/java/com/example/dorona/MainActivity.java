package com.example.dorona;

import android.Manifest;
import android.app.AlarmManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.location.Address;
import android.location.Geocoder;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.firebase.firestore.FirebaseFirestore;
import com.karumi.dexter.Dexter;
import com.karumi.dexter.PermissionToken;
import com.karumi.dexter.listener.PermissionDeniedResponse;
import com.karumi.dexter.listener.PermissionGrantedResponse;
import com.karumi.dexter.listener.PermissionRequest;
import com.karumi.dexter.listener.single.PermissionListener;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import static android.content.Context.ALARM_SERVICE;
import static androidx.core.content.ContextCompat.getSystemService;

public class MainActivity extends FlutterActivity{
    static MainActivity instance;
    public String userId;
    public static MainActivity getInstance() {
        return instance;
    }

    LocationRequest locationRequest;
    FusedLocationProviderClient fusedLocationProviderClient;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        instance = this;

    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "Location")
                    .setMethodCallHandler((call, result) -> {
                                if (call.method.equals("startLocation")) {
                                    userId = call.argument("userId").toString();
//                                    NewThread thread = new NewThread(userId, this);
//                                    thread.start();
//                                    updateLocation(userId);
                                    Intent intent=new Intent(this,MyForegroundLocationService.class);
                                    if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.O){
                                        startForegroundService(intent);
                                    }else{
                                        startService(intent);
                                    }
                                }
                                if (call.method.equals("bluetooth")) {
                                    // final BluetoothManager manager = (BluetoothManager) getSystemService(BLUETOOTH_SERVICE);
                                    //   System.out.println("Bluetooth Address:"+manager.getAdapter().getName());
                                    Intent intent = new Intent(this, MyBluetoothConnectivity.class);
                                    PendingIntent pendingIntent = PendingIntent.getBroadcast(this, 1111, intent, 0);
                                    AlarmManager alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);
                                    alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + 1000, 12000, pendingIntent);
                                    Intent intent1 = new Intent(this, MyBluetoothActionFound.class);
                                    intent1.setAction(BluetoothDevice.ACTION_FOUND);
                                    PendingIntent pendingIntent1 = PendingIntent.getBroadcast(this, 1112, intent1, 0);
                                    //  AlarmManager alarmManager1=(AlarmManager) getSystemService(ALARM_SERVICE);
                                    // alarmManager1.setRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis()+1000,60000,pendingIntent1);
                                    //                        IntentFilter filter=new IntentFilter();
                                    //                        filter.addAction(BluetoothDevice.ACTION_FOUND);
                                    //                        registerReceiver(new MyBluetoothActionFound(),filter);
                                    String macAddress = Settings.Secure.getString(getContentResolver(), "bluetooth_address");
                                    System.out.println(macAddress);
                                }
                                if (call.method.equals("getBluetoothAddress")) {
                                    //                        String macAddress= Settings.Secure.getString(getContentResolver(),"bluetooth_address");
                                    //                        result.success(macAddress);
                                    BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
                                    try {
                                        Field mServiceField = bluetoothAdapter.getClass().getDeclaredField("mService");
                                        mServiceField.setAccessible(true);
                                        Object btManagerService = mServiceField.get(bluetoothAdapter);
                                        if (btManagerService != null) {
                                            String macAddress = (String) btManagerService.getClass().getMethod("getAddress").invoke(btManagerService);
                                            result.success(macAddress);
                                        }
                                    } catch (NoSuchFieldException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
                                        e.printStackTrace();
                                        System.out.println(e);
                                    }

                                }
                                if (call.method.equals("getAddressFromCoordinates")) {
                                    double latitude = Double.valueOf(call.argument("latitude"));
                                    double longitude = Double.valueOf(call.argument("longitude"));
                                    Map<String, String> address = new HashMap<String, String>();
                                    Geocoder geocoder;
                                    geocoder = new Geocoder(this, Locale.getDefault());
                                    List<Address> addresses;
                                    try {
                                        addresses = geocoder.getFromLocation(latitude, longitude, 1);
                                        System.out.println(addresses.get(0).getLocality());
                                        System.out.println(addresses.get(0).getPostalCode());
                                        address.put("adminArea", addresses.get(0).getAdminArea());
                                        address.put("subAdminArea", addresses.get(0).getSubAdminArea());
                                        address.put("pincode", addresses.get(0).getPostalCode());
                                        result.success(address);

                                    } catch (IOException e) {
                                        e.printStackTrace();
                                    }

                                }
                                if(call.method.equals("setRepeatingVaccineSlotReminder")){
                                    AlarmManager alarmManager =(AlarmManager) getApplicationContext().getSystemService(Context.ALARM_SERVICE);
                                    Intent intent = new Intent();
                                    PendingIntent pendingIntent = PendingIntent.getService(this, 10, intent,PendingIntent.FLAG_NO_CREATE);
                                    

                                }
                            }
                    );
        }
    }

    class NewThread extends Thread {
        String userId;
        Context context;

        NewThread(String uid, Context context1) {
            userId = uid;
            context = context1;
        }

        ;

        @Override
        public void run() {
            System.out.println("location service  start");
            Intent intent = new Intent(context, MyLocationBroadcast.class);
            intent.putExtra("userId",userId);
            System.out.println(userId+ "from thread");
            PendingIntent pendingIntent = PendingIntent.getBroadcast(context.getApplicationContext(), 2222, intent, 0);
            AlarmManager alarmManager = (AlarmManager) context.getSystemService(ALARM_SERVICE);
            alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + 1000, 5000, pendingIntent);

        }
    }

    void updateLocation(String userId) {
        System.out.println("UPDATE LOCATION CALL HUA HAI");
        buildLocationRequest();
        fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(this);
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return;
        }
        fusedLocationProviderClient.requestLocationUpdates(locationRequest, getPendingIntent(userId));
    }
    PendingIntent getPendingIntent(String userId){
        Intent intent=new Intent(this,MyLocationService.class);
        intent.setAction(MyLocationService.ACTION_PROCESS_UPDATE);
        return PendingIntent.getBroadcast(this,456,intent,PendingIntent.FLAG_UPDATE_CURRENT);
    }
    void buildLocationRequest(){
        locationRequest=new LocationRequest();
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY)
                .setInterval(5000)
                .setFastestInterval(3000)
                .setSmallestDisplacement(10f);
    }

}

