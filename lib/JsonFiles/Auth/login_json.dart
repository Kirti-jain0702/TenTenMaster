import 'package:json_annotation/json_annotation.dart';

///This allows the `Login` class to access private members in the generated file.
part 'login_json.g.dart';

@JsonSerializable()
class Login {
  final String token;
  final String role;

  Login({this.token, this.role});

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  Map<String, dynamic> toJson() => _$LoginToJson(this);
}

//class LoginSession {
//  Map<String, String> headers = {};
////  dynamic body;
//
//  Future<Map> get() async {
//    http.Response response = await http.get(url, headers: headers);
//
////    body = json.decode(response.body);
//    return json.decode(response.body);
//  }
//
//  Future<Map> post(dynamic body) async {
//    http.Response response = await http.post(url, body: body, headers: headers);
//    return json.decode(response.body);
//  }
//}
