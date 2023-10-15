import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothCheckController extends GetxController {
  final _bluetoothState = Rx<BluetoothState>(BluetoothState.unknown);

  set bluetoothState(value) => _bluetoothState.value = value;

  @override
  void onReady() {
    super.onReady();
    //블루투스 상태에 변하면 moveToPage 메소드를 이용해서 라우팅
    ever(_bluetoothState, (_) => moveToPage());
    //블루투스 상태의 Stream을 전달받음.
    //_bluetoothState.bindStream(flutterBlue.state);
  }

  void moveToPage() {
    if (_bluetoothState.value == BluetoothState.on) {
      //블루투스가 켜져 있다면, 앱으로 라우팅
      //Get.off(() => const OnBoard(), transition: Transition.fadeIn);
    } else {
      //그렇지 않은 경우 앱을 이용하지 못하는 페이지로 라우팅
      //Get.off(() => const Check(), transition: Transition.fadeIn);
    }
  }
}