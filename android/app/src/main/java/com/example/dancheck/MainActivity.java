package com.example.dancheck;

import io.flutter.embedding.android.FlutterActivity;

import android.os.Build;
import android.content.Intent;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import org.json.JSONArray;
import org.json.JSONObject;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.os.Handler;
import android.os.Message;
import android.os.RemoteException;
import android.os.Bundle;

import org.altbeacon.beacon.Beacon;
import org.altbeacon.beacon.BeaconConsumer;
import org.altbeacon.beacon.BeaconManager;
import org.altbeacon.beacon.BeaconParser;
import org.altbeacon.beacon.BeaconTransmitter;
import org.altbeacon.beacon.RangeNotifier;
import org.altbeacon.beacon.Region;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class MainActivity extends FlutterActivity implements BeaconConsumer{
 
    boolean flag = false;
    private BeaconManager beaconManager; // [비콘 매니저 객체]
    private List<Beacon> beaconList = new ArrayList<>(); // [실시간 비콘 감지 배열]
    private List<Map<String, String>> beaconMapList = new ArrayList<Map<String, String>>();
    int beaconScanCount = 1; // [비콘 스캔 횟수를 카운트하기 위함]
    ArrayList beaconFormatList = new ArrayList<>(); // [스캔한 비콘 리스트를 포맷해서 저장하기 위함]

    // TODO [비콘 신호 활성 관련 전역 변수]
    Beacon beacon; // [비콘 객체]
    BeaconParser beaconParser; // [비콘 파서 객체]
    BeaconTransmitter beaconTransmitter; // [BeaconTransmitter]
    String sendUuid = ""; // [UUID : 비콘 신호 활성 시 사용하는 값]
    String sendMajor = ""; // [MAJOR : 비콘 신호 활성 시 사용하는 값]
    String sendMinor = ""; // [MINOR : 비콘 신호 활성 시 사용하는 값]

    @Override
    @RequiresApi(api = Build.VERSION_CODES.O)
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        final MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), "com.example.dancheck");
        channel.setMethodCallHandler(handler);
    }

    private MethodChannel.MethodCallHandler handler = (methodCall, result) -> {
        if (methodCall.method.equals("scanBeacon")) {
            if(flag == false){
                
                startBeaconScan();
                result.success("running");
            } 
            else{
                stopBeaconScan();
                result.success("stop");
            }  		
            
        } else if (methodCall.method.equals("displayBeacon")) {
            if(beaconList.size() > 0) {
                Beacon b = beaconList.iterator().next();
                //result.success("UUID: " + b.getId1().toString() +  "\nMAJOR: " + b.getId2().toString()+  "\nMIMOR: " + b.getId3().toString()+  "\nRSSI: " + b.getRssi());
                result.success(beaconMapList);
            }
        } else {
            result.notImplemented();
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);

        try {
            // [비콘 매니저 생성]
            beaconManager = BeaconManager.getInstanceForApplication(this);

            // [블루투스가 스캔을 중지하지 않도록 설정]
            beaconManager.setEnableScheduledScanJobs(false); // TODO 이코드를 설정해야 지맘대로 블루투스가 스캔을 중지하지 않는다.
            //beaconManager.setRegionStatePeristenceEnabled(false);

            // [레이아웃 지정 - IOS , Android 모두 스캔 가능]
            beaconManager.getBeaconParsers().add(new BeaconParser().setBeaconLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25"));

        }
        catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void onBeaconServiceConnect() {
        RangeNotifier rangeNotifier = new RangeNotifier() {
            @Override
            public void didRangeBeaconsInRegion(Collection<Beacon> beacons, Region region) {
                // [비콘이 감지되면 해당 함수가 호출]
                // TODO [비콘들에 대응하는 Region 객체가 들어들어옴]
                if (beacons.size() > 0) {

                    if (beaconList != null){
                        beaconList.clear();
                        beaconMapList.clear();
                    }

                    for (Beacon beacon : beacons) {
                        if (beaconList != null){
                            Map<String, String> map = new HashMap<String, String>();
                            map.put("UUID", beacon.getId1().toString());
                            map.put("MAJOR", beacon.getId2().toString());
                            map.put("MINOR", beacon.getId3().toString());
                            map.put("RSSI", beacon.getRssi() + "");
                            beaconMapList.add(map);
                            beaconList.add(beacon);
                        }
                    }
                }
                else {
                    // TODO [실시간 스캔 반영을 위해 스캔 된 것이 없어도 기존 목록 초기화 실시]
                    if (beaconList != null && beaconList.size() > 0){
                        //beaconList.clear();
                    }
                }
            }
        };
        try {
            beaconManager.startRangingBeaconsInRegion(new Region("AC:23:3F:F6:BD:71", null, null, null));
            beaconManager.addRangeNotifier(rangeNotifier);
        }
        catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    Handler beaconScanHandler = new Handler() {
        public void handleMessage(Message msg) {
            try {
                // [기존에 저장된 배열 데이터 초기화 실시]
                if(beaconFormatList != null && beaconFormatList.size() > 0){
                    beaconFormatList.clear();
                }

                // [for 문 사용해 실시간 스캔된 비콘 개별 정보 확인]
                if (beaconList != null){
                    for(Beacon beacon : beaconList){
                        // [스캔한 비콘 정보 포맷 실시]
                        JSONObject jsonBeacon = new JSONObject();

                        // [UUID : 소문자 변환]
                        jsonBeacon.put("uuid", String.valueOf(beacon.getId1().toString().toLowerCase()));

                        // [minor (36)]
                        jsonBeacon.put("minor", String.valueOf(beacon.getId3().toString()));

                        // [major (1)]
                        jsonBeacon.put("major", String.valueOf(beacon.getId2().toString()));

                        // [배열에 데이터 저장 실시]
                        beaconFormatList.add(jsonBeacon.toString());

                    } // [for 문 종료]
                }

                // [비콘 스캔 카운트 증가]
                beaconScanCount ++;

                // [핸들러 자기 자신을 1초마다 호출]
                beaconScanHandler.sendEmptyMessageDelayed(0, 1000);
            }
            catch (Exception e){
                e.printStackTrace();
            }
        }
    };

    // TODO [SEARCH FAST] : [비콘 스캔 수행]
    public void startBeaconScan(){
        try {
            flag = !flag;
            // [비콘 스캔 카운트 변수값 초기화 실시]
            beaconScanCount = 1;

            // [비콘 배열 데이터 초기화 실시]
            if (beaconList != null && beaconList.size()>0){
                beaconList.clear();
            }
            if (beaconFormatList != null && beaconFormatList.size()>0){
                beaconFormatList.clear();
            }

            // [beaconManager Bind 설정]
            beaconManager.bind(this);

            // [실시간 비콘 스캔 수행 핸들러 호출]
            beaconScanHandler.sendEmptyMessage(0);
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }

    // TODO [SEARCH FAST] : [비콘 스캔 종료]
    public void stopBeaconScan(){
        try {
            flag = !flag;
            // -----------------------------------------
            // [비콘 스캔 카운트 초기화]
            beaconScanCount = 1;
            // -----------------------------------------
            // [비콘 배열 데이터 초기화 실시]
            if (beaconList != null && beaconList.size()>0){
            //    beaconList.clear();
            }
            if (beaconFormatList != null && beaconFormatList.size()>0){
            //    beaconFormatList.clear();
            }
            // -----------------------------------------
            // [핸들러 사용 종료]
            try {
                if (beaconScanHandler != null){
                    beaconScanHandler.removeMessages(0);
                    beaconScanHandler.removeCallbacks(null);
                }
            }
            catch (Exception e){
                e.printStackTrace();
            }
            // -----------------------------------------
            // [beaconManager Bind 해제]
            try {
                if(beaconManager != null){
                    beaconManager.unbind(this);
                }
            }
            catch (Exception e){
                e.printStackTrace();
            }
            // -----------------------------------------
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }
}
