import 'package:delivoo/Constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  SharedPreferences prefs;
  @override
  Future onRequest(RequestOptions options) async {
    final hasAuthHeader = options.headers.containsKey(HeaderKeys.authHeaderKey);
    final hasNoAuthHeader =
        options.headers.containsKey(HeaderKeys.noAuthHeaderKey);
    if (hasNoAuthHeader) {
      options.headers.remove(HeaderKeys.authHeaderKey);
      options.headers.remove(HeaderKeys.noAuthHeaderKey);
      return;
    }
    if (hasAuthHeader) {
      var token = await getToken();
      options.headers[HeaderKeys.authHeaderKey] = "Bearer $token";
    }

    options.queryParameters.removeWhere((key, value) => value == null);
  }

  Future<String> getToken() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    // print('token: ' + prefs.getString('token'));
    return prefs.getString('token');
  }
}
