import 'package:full_comics_frontend/config/app_constant.dart';
import 'package:http/http.dart';

class ApiClient {
  final String _baseServerUrl;

  const ApiClient({required String baseServerUrl})
      : _baseServerUrl = baseServerUrl;

  Future<Response> getData(String uri) async {
    try {
      final response = await get(Uri.parse(_baseServerUrl + uri)).timeout(
        const Duration(seconds: AppConstant.timeout),
        onTimeout: () {
          return Response('Error', 408);
        },
      );
      return response;
    } catch (e) {
      return Response(e.toString(), 404);
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      final response =
          await post(Uri.parse(_baseServerUrl + uri), body: body).timeout(
        const Duration(seconds: AppConstant.timeout),
        onTimeout: () {
          return Response('Error', 408);
        },
      );
      return response;
    } catch (e) {
      return Response(e.toString(), 404);
    }
  }
}
