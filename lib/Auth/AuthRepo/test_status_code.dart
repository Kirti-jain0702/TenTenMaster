import 'package:dio/dio.dart';

class TestStatusCode {
  static bool check(Object obj, int statusCode) {
    // non-200 error goes here.
    switch (obj.runtimeType) {
      case DioError:
        final res = (obj as DioError).response;
        if (res.statusCode == statusCode) {
          return true;
        } else {
          return false;
        }
        break;
      default:
        return false;
    }
  }
}
