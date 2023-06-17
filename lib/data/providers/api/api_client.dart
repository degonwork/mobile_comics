import 'package:http/http.dart';

class ApiClient {
  final String _baseServerUrl;

  const ApiClient({required String baseServerUrl})
      : _baseServerUrl = baseServerUrl;

  Future<Response> getData(String uri) async {
    final response = await get(Uri.parse(_baseServerUrl + uri))
        .timeout(const Duration(seconds: 2), onTimeout: () {
      return Response('Error', 408);
    });
    return response;
  }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      final response = await post(Uri.parse(_baseServerUrl + uri), body: body);
      return response;
    } catch (e) {
      return Response(e.toString(), 404);
    }
  }
}
