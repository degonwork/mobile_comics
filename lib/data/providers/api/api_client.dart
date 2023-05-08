import 'package:http/http.dart';

class ApiClient {
  final String _baseServerUrl;

  const ApiClient({required String baseServerUrl})
      : _baseServerUrl = baseServerUrl;

  Future<Response> getData(String uri) async {
    try {
      final response = await get(Uri.parse(_baseServerUrl + uri));
      return response;
    } catch (e) {
      return Response(e.toString(), 1);
    }
  }
}
