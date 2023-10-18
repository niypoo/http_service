// ignore_for_file: avoid_print

import 'package:get/get.dart';

class HttpService extends GetxService {
  //define this controller in static to
  static HttpService get to => Get.find();

  // define client
  final GetConnect client = GetConnect();

  Future<HttpService> init({
    required String baseUrl,
  }) async {
    // BASE URL
    client.baseUrl = baseUrl;

    // the solution of handshake
    client.allowAutoSignedCert = true;

    //Authenticator will be called 3 times if HttpStatus is
    client.maxAuthRetries = 3;
    return this;
  }

  void setHeader(String key, String value) {
    // assign token
    client.httpClient.addRequestModifier((dynamic request) async {
      request.headers[key] = value;
      return request;
    });
  }

  Future<dynamic> responseHandle(Function httpCallback) async {
    try {
      final Response response = await httpCallback();
      print('[[HTTP BASE_URL]] -> ${client.baseUrl}  [[HTTP RESPONSE]] hasError - ${response.hasError}[[HTTP RESPONSE]] statusCode - ${response.statusCode}');

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
