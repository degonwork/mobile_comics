import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../config/app_constant.dart';
import '../models/device_model.dart';
import '../providers/api/api_client.dart';

class DeviceRepo {
  final ApiClient _apiClient;
  final String _deviceUrl;

  DeviceRepo({
    required ApiClient apiClient,
    required String deviceUrl,
  })  : _apiClient = apiClient,
        _deviceUrl = deviceUrl;

  Future<void> registerDevice() async {
    await createUuidDeviceToLocal();
    Device device = await readDeviceFromLocal();
    await _apiClient.postData(
      '$_deviceUrl${AppConstant.registerDeviceUrl}',
      device.toMap(),
    );
    // print("Registed Device");
  }

  Future<void> createUuidDeviceToLocal() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey(AppConstant.uuidDevice)) {
      // print("uuid device is not available");
      String uuidDevice = const Uuid().v4();
      await sharedPreferences.setString(AppConstant.uuidDevice, uuidDevice);
      // print("Create uuid device");
    } else {
      // print("uuid device is available");
    }
  }

  Future<Device> readDeviceFromLocal() async {
    String? fireBaseToken;
    String? deviceId;
    final sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey(AppConstant.firebaseToken)) {
      fireBaseToken = sharedPreferences.getString(AppConstant.firebaseToken);
    }
    if (sharedPreferences.containsKey(AppConstant.uuidDevice)) {
      deviceId = sharedPreferences.getString(AppConstant.uuidDevice);
    }
    return Device(device_id: deviceId, firebase_token: fireBaseToken);
  }
}
