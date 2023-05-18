import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_constant.dart';
import '../providers/device/device_service.dart';
import '../providers/firebase/notification/firebase_messaging_service.dart';

class DeviceRepo {
  Future<void> createDeviceToLocal() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? firebaseToken = await FireBaseMessagingService.getToken();
    if (firebaseToken != null &&
        !sharedPreferences.containsKey(AppConstant.FIREBASETOKEN)) {
      print("firebase token is not available");
      await sharedPreferences.setString(
          AppConstant.FIREBASETOKEN, firebaseToken);
      print("Create firebaseToken");
    }
    final deviceService = DeviceService();
    deviceService.setDeviceId(sharedPreferences);
  }
}
