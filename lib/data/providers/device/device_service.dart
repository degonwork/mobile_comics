import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/app_constant.dart';

class DeviceService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final AndroidId _androidId = const AndroidId();

  Future<String?> setDeviceId(SharedPreferences sharedPreferences) async {
    final String? deviceID;
    if (Platform.isAndroid) {
      deviceID = await _androidId.getId();
      if (deviceID != null &&
          !sharedPreferences.containsKey(AppConstant.DEVICEID)) {
        print("Device ID is not available");
        await sharedPreferences.setString(AppConstant.DEVICEID, deviceID);
        print("Create deviceId for android");
      }
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      deviceID = iosInfo.identifierForVendor;
      if (deviceID != null &&
          sharedPreferences.containsKey(AppConstant.DEVICEID)) {
        print("Device ID is not available");
        await sharedPreferences.setString(AppConstant.DEVICEID, deviceID);
        print("Create deviceId for ios");
      }
    }
    return null;
  }
}
