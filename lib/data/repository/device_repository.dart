import 'package:full_comics_frontend/data/providers/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../config/app_constant.dart';
import '../models/device_model.dart';
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
      '$_deviceUrl${AppConstant.registerDeviceUrl}',
      device.toMap(),
    );
    print("Registed Device");
  }

  Future<void> createDeviceToLocal() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? firebaseToken = await FireBaseMessagingService.getToken();
    if (firebaseToken != null &&
        !sharedPreferences.containsKey(AppConstant.firebaseToken)) {
      print("firebase token is not available");
      await sharedPreferences.setString(
          AppConstant.firebaseToken, firebaseToken);
      print("Create firebaseToken");
    }
    if (!sharedPreferences.containsKey(AppConstant.uuidDevice)) {
      print("uuid device is not available");
      String uuidDevice = const Uuid().v4();
      await sharedPreferences.setString(AppConstant.uuidDevice, uuidDevice);
      print("Create uuid device");
    }
    print("Created Device to local");
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
