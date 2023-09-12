import 'package:get/get.dart';

class HttpService extends GetxService {
  //define this controller in static to
  static HttpService get to => Get.find();

  // define client
  final GetConnect client = GetConnect();

  Future<HttpService> init({
    required String baseUrl,
    required Future<String> Function() getToken,
  }) async {
    // BASE URL
    client.baseUrl = baseUrl;

    // the solution of handshake
    client.allowAutoSignedCert = true;

    // assign token
    client.httpClient.addRequestModifier((dynamic request) async {
      final String token = await getToken();
      request.headers['Authorization'] = token;
      return request;
    });

    //Authenticator will be called 3 times if HttpStatus is
    client.maxAuthRetries = 3;
    return this;
  }

  Future<dynamic> responseHandle(Function httpCallback) async {
    try {
      final Response response = await httpCallback();
      print('[[HTTP RESPONSE]] hasError - ${response.hasError}');
      print('[[HTTP RESPONSE]] statusCode - ${response.statusCode}');
      print('[[HTTP RESPONSE]] statusText - ${response.statusText}');
      print('[[HTTP RESPONSE]] body - ${response.body}');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return Future.error(response.body.toString());
      }
    } catch (error) {
      print('[[HTTP RESPONSE]] statusText - ${error.toString()}');

      return Future.error(error.toString());
    }
  }
}
