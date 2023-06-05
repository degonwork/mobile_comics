class Device {
  final String? device_id;
  final String? firebase_token;

  const Device({required this.device_id, required this.firebase_token});

  Map<String, dynamic> toMap() {
    return {
      "device_id": device_id,
      "firebase_token": firebase_token,
    };
  }
}
