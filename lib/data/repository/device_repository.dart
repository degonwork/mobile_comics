import 'package:full_comics_frontend/data/providers/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_constant.dart';
import '../models/device_model.dart';
import '../providers/device/device_service.dart';
import '../providers/firebase/notification/firebase_messaging_service.dart';

class DeviceRepo {
  final ApiClient _apiClient;
  final String _deviceUrl;

  DeviceRepo({
    required ApiClient apiClient,
    required String deviceUrl,
  })  : _apiClient = apiClient,
        _deviceUrl = deviceUrl;

  Future<void> registerDevice() async {
    await createDeviceToLocal();
    Device device = await readDeviceFromLocal();
    await _apiClient.postData(
      '$_deviceUrl${AppConstant.REGISTERDEVICEURL}',
      device.toMap(),
    );
    print("Registed Device");
  }

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
    await deviceService.setDeviceId(sharedPreferences);
    print("Created Device to local");
  }

  Future<Device> readDeviceFromLocal() async {
    String? fireBaseToken;
    String? deviceId;
    final sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey(AppConstant.FIREBASETOKEN)) {
      fireBaseToken = sharedPreferences.getString(AppConstant.FIREBASETOKEN);
    }
    if (sharedPreferences.containsKey(AppConstant.DEVICEID)) {
      deviceId = sharedPreferences.getString(AppConstant.DEVICEID);
    }
    return Device(device_id: deviceId, firebase_token: fireBaseToken);
  }
}
