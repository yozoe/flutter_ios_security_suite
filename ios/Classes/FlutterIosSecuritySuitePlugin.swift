import Flutter
import UIKit

import IOSSecuritySuite

public class FlutterIosSecuritySuitePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_ios_security_suite", binaryMessenger: registrar.messenger())
    let instance = FlutterIosSecuritySuitePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "amIJailbroken":
      result(IOSSecuritySuite.amIJailbroken())
    case "amIDebugged":
        result(IOSSecuritySuite.amIDebugged())
    case "amIReverseEngineered":
        result(IOSSecuritySuite.amIReverseEngineered())
    case "amITampered":
        
        guard let params = call.arguments as? [String: Any] else {
            result(true)
            return
        }

        guard let a = params["a"] as? String, let b = params["b"] as? String else {
            result(true)
            return
        }

        let condition1 = IOSSecuritySuite.amITampered([FileIntegrityCheck.bundleID(a)])
        let condition2 = IOSSecuritySuite.amITampered([FileIntegrityCheck.mobileProvision(b)])
        
        result(condition1.result && condition2.result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
