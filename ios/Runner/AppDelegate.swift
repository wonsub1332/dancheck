import UIKit
import Flutter
import CoreLocation
import CoreBluetooth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
          
      // 작성된 코드 영역 시작
      
      // MethodChannel 연결
      let controller = window?.rootViewController as! FlutterViewController
      let channel: FlutterMethodChannel = FlutterMethodChannel(
        name: "com.example.native_connection_study",
        binaryMessenger: controller.binaryMessenger)
      
      // 핸들러를 이용한 네이티브 코드 실행
      channel.setMethodCallHandler({
          [weak self] (methodCall: FlutterMethodCall, result: FlutterResult) -> Void in
          // Flutter코드에서 명시된 호출명 구분
          if(methodCall.method == "getNativeData") {
              result(self?.getNativeData(arguments: methodCall.arguments))
              return
          }
          
          result(FlutterMethodNotImplemented)
      })
      // 작성된 코드 영역 끝
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // 새로 작성한 함수
    private func getNativeData(arguments:Any?) -> Any {
        // Flutter에서 arguments가 전달될 때는 어차피 배열로 전달되므로 Array<Any>?로 캐스팅한다.
        let args = arguments as? Array<Any>
        
        // Flutter로 전달해줄 예제 데이터 생성
        let jsonData : [String: Any] = [
            "name": args?[0] ?? "None",
            "age": args?[1] ?? "None"
        ] as Dictionary
        
        // Json으로 변환
        var jsonObj : String = ""
        do {
            let jsonCreate = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            jsonObj = String(data: jsonCreate, encoding: .utf8) ?? ""
        }catch{
            jsonObj = ""
        }
        return jsonObj
    }
    
}
