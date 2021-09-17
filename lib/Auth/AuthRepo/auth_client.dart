import 'package:delivoo/AppConfig/app_config.dart';
import 'package:delivoo/Constants/constants.dart';
import 'package:delivoo/JsonFiles/Auth/Responses/login_response.dart';
import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo/JsonFiles/Auth/check_user_json.dart';
import 'package:delivoo/JsonFiles/Auth/login_json.dart';
import 'package:delivoo/JsonFiles/Auth/register_json.dart';
import 'package:delivoo/JsonFiles/Auth/social_login_json.dart';
import 'package:delivoo/JsonFiles/Auth/social_register_user.dart';
import 'package:delivoo/JsonFiles/Support/support_json.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class AuthClient {
  factory AuthClient(Dio dio, {String baseUrl}) = _AuthClient;

  @POST('api/check-user')
  Future<void> checkUser(@Body() CheckUser checkUser);

  @POST('api/register')
  Future<void> registerUser(@Body() RegisterUser registerUser);

  @POST('api/register')
  Future<void> socialRegisterUser(
      @Body() SocialRegisterUser socialRegisterUser);

  @POST('api/login')
  Future<LoginResponse> login(@Body() Login login);

  @POST('api/social/login')
  Future<LoginResponse> socialLogin(@Body() SocialLoginUser socialLoginUser);

  @POST('api/support')
  Future<void> createSupport(@Body() Support support);

  @PUT('api/user')
  Future<UserInformation> updateUser(
      @Body() Map<String, dynamic> updateUserRequest,
      [@Header(HeaderKeys.authHeaderKey) String token]);
}
