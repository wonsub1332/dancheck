import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BeaconScanner with ChangeNotifier {
  bool _state = false;
  bool get state => _state;

  static const MethodChannel _channel = MethodChannel('com.example.dancheck');

  scanBeacon() async {
    final String flag = await _channel.invokeMethod('scanBeacon');
    const String _beacon = 'e2c56db5-dffb-48d2-b060-d0f5a71096e1';
    String rssi = '';
    int checkcount = 0;
    bool isScan = false;
    int smin =
        DateTime.now().hour * 60 + DateTime.now().minute + 200; //수업 시작 시각 (임시)
    int emin =
        DateTime.now().hour * 60 + DateTime.now().minute + 400; //수업 종료 시각 (임시)
    Future<List<Object?>> beaconList;
    Timer? timer;
    if (flag.compareTo("running") == 0) {
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        print(checkcount);
        beaconList = displayBeacon();
        beaconList.then((result) {
          for (int i = 0; i < result.length; i++) {
            Map<Object?, Object?> map = result[i] as Map<Object?, Object?>;
            if ((map['UUID'] as String?)!.compareTo(_beacon) == 0) {
              rssi = (map['RSSI'] as String?)!;
              break;
            }
          }
          if (rssi != 'null' && int.parse(rssi) > -90 && checkcount < 5) {
            checkcount++;
          } else if ((rssi == 'null' || int.parse(rssi) < -90) &&
              checkcount > 0) {
            checkcount--;
          }

          if (checkcount == 5 && !isScan) {
            isScan = !isScan;
            if (smin > (DateTime.now().hour * 60 + DateTime.now().minute)) {
              print('출석');
            } else {
              print('지각');
            }
            _state = true;
            notifyListeners();
          } else if (checkcount == 0 && isScan) {
            isScan = !isScan;
            _state = false;
            notifyListeners();
          }

          if (DateTime.now().hour * 60 + DateTime.now().minute >= emin) {
            print('종료');
            timer?.cancel();
            timer = null;
          }
        });
      });
    }
    if (flag.compareTo("stop") == 0) {
      rssi = 'null';
      checkcount = 0;
      timer?.cancel();
      timer = null;
    }
  }

  Future<List<Object?>> displayBeacon() async {
    final List<Object?> uuid = await _channel.invokeMethod('displayBeacon');
    return uuid;
  }
}
