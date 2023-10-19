// ignore_for_file: avoid_print

import 'package:get/get.dart';

class HttpService extends GetxService {
  //define this controller in static to
  static HttpService get to => Get.find();

  // define client
  final GetConnect client = GetConnect();

  final bool production;

  HttpService({this.production = false});

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

      printDev(
          '[[HTTP BASE_URL]] -> ${client.baseUrl}  [[HTTP RESPONSE]] hasError - ${response.hasError}[[HTTP RESPONSE]] statusCode - ${response.statusCode}');
      printDev('[[HTTP body]] ->  ${response.body}');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return Future.error(response.body.toString());
      }
    } catch (error) {
      printDev('[[HTTP RESPONSE]] statusText - ${error.toString()}');
      return Future.error(error.toString());
    }
  }

  // show error message only in dev-mode
  void printDev(dynamic text) {
    if (production == true) return;
    print(text);
  }
}
