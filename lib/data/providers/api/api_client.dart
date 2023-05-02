import 'package:http/http.dart';

class ApiClient {
  final String _baseUrlServer;

  const ApiClient({required String baseUrl}) : _baseUrlServer = baseUrl;

  Future<Response> getData(String uri) async {
    try {
      final response = await get(Uri.parse(_baseUrlServer + uri));
      return response;
    } catch (e) {
      return Response(e.toString(), 1);
    }
  }
}
