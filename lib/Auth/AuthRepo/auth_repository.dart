import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:delivoo/Auth/AuthRepo/test_status_code.dart';
import 'package:delivoo/Auth/Verification/cubit/verification_cubit.dart';
import 'package:delivoo/JsonFiles/Auth/Responses/login_response.dart';
import 'package:delivoo/JsonFiles/Auth/Responses/sign_up_response.dart';
import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';
import 'package:delivoo/JsonFiles/Auth/check_user_json.dart';
import 'package:delivoo/JsonFiles/Auth/login_json.dart';
import 'package:delivoo/JsonFiles/Auth/register_json.dart';
import 'package:delivoo/JsonFiles/Auth/social_login_json.dart';
import 'package:delivoo/JsonFiles/Auth/social_register_user.dart';
import 'package:delivoo/JsonFiles/Notification/notification.dart';
import 'package:delivoo/JsonFiles/Support/support_json.dart';
import 'package:delivoo/JsonFiles/User/update_user_request.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_client.dart';
import 'auth_interceptor.dart';

class AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'profile'],
  );

  final FacebookLogin _facebookLogin = FacebookLogin();

  final Dio dio;
  final AuthClient client;
  String _verificationId;
  int _resendToken;

  AuthRepo._(this.dio, this.client);

  factory AuthRepo() {
    Dio dio = Dio();
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
    AuthClient client = AuthClient(dio);
    dio.options.headers = {
      "content-type": "application/json",
      'Accept': 'application/json',
    };
    return AuthRepo._(dio, client);
  }

  Future<UserInformation> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return UserInformation.fromJson(json.decode(prefs.get('user_info')));
  }

  Future<SignUpResponse> getSocialUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return SignUpResponse.fromJson(jsonDecode(prefs.get('sign_up_info')));
  }

  Future<void> saveUser(UserInformation user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_info', json.encode(user.toJson()));
  }

  String get phoneNumber => _firebaseAuth.currentUser.phoneNumber;

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    bool isLoggedIn = await isSignedInWithSocial();
    if (currentUser != null || isLoggedIn)
      return true;
    else
      return false;
  }

  ///check whether the user is registered or not
  Future<bool> isRegistered(String number) {
    CheckUser checkUser = CheckUser(mobileNumber: number);
    return client.checkUser(checkUser).then((value) => true).catchError(
        (Object obj) => false,
        test: (obj) => TestStatusCode.check(obj, 422));
  }

  ///register user
  Future<void> registerUser(String phoneNumber, String name, String email) {
    RegisterUser registerUser = RegisterUser(
      name: name,
      email: email,
      role: 'customer',
      mobileNumber: phoneNumber,
    );
    return client.registerUser(registerUser);
  }

  ///register social(google and facebook) user
  Future<void> socialRegisterUser(
      String phoneNumber, String name, String email, String image) {
    SocialRegisterUser socialRegisterUser = SocialRegisterUser(
      name: name,
      email: email,
      role: 'customer',
      mobileNumber: phoneNumber,
      image: image,
    );
    return client.socialRegisterUser(socialRegisterUser);
  }

  ///phone number Sign In
  // Future<Null> signInWithPhoneNumber(
  //     AuthCredential authCredential, String phoneNumber) async {
  //   await _firebaseAuth.signInWithCredential(authCredential);
  //   var user = _firebaseAuth.currentUser;
  //   var idToken = await user.getIdToken();
  //   print(idToken);
  //   Login login = Login(token: idToken, role: 'customer');
  //   final loginResponse = await client.login(login);
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('token', loginResponse.token);
  //   await saveUser(loginResponse.userInfo);
  //   await updateNotificationId();
  // }

  Future<LoginResponse> signInWithPhoneNumber(String fireToken) async {
    Login loginRequest = Login(token: fireToken, role: 'delivery');
    return await client.login(loginRequest);
  }

  AuthCredential getCredential(String verId, String otp) {
    AuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: otp);
    return credential;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      _facebookLogin.logOut(),
    ]);
  }

  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    print(googleAuth.idToken);
    SocialLoginUser socialLoginUser = SocialLoginUser(
        os: Platform.isAndroid ? 'android' : 'ios',
        platform: 'google',
        token: googleAuth.idToken,
        role: 'customer');
    return _socialLogin(socialLoginUser);
  }

  Future<bool> signInWithFacebook() async {
    final FacebookLoginResult result =
        await _facebookLogin.logIn(['email', 'public_profile']);
    final FacebookAccessToken accessToken = result.accessToken;
    // final graphResponse = await dio.get(
    //     'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${accessToken.token}');
    // final profile = jsonDecode(graphResponse.data);
    SocialLoginUser socialLoginUser = SocialLoginUser(
        os: Platform.isAndroid ? 'android' : 'ios',
        platform: 'facebook',
        token: accessToken.token,
        role: 'customer');
    // await saveUserPhoto(profile["picture"]["data"]["url"]);
    return _socialLogin(socialLoginUser);
  }

  Future<bool> _socialLogin(SocialLoginUser socialLoginUser) async {
    final prefs = await SharedPreferences.getInstance();
    return client.socialLogin(socialLoginUser).then((loginResponse) async {
      ///store token in shared preference
      print(loginResponse.token);
      prefs.setString('token', loginResponse.token);
      await saveUser(loginResponse.userInfo);
      return true;
    }).catchError((obj) {
      final socialSignUpRes = (obj as DioError).response;
      prefs.setString('sign_up_info', jsonEncode(socialSignUpRes.data));
      return false;
    }, test: (obj) => TestStatusCode.check(obj, 404));
  }

  Future<bool> isSignedInWithSocial() async {
    bool isGoogleSignedIn = await _googleSignIn.isSignedIn();
    bool isFacebookSignedIn = await _facebookLogin.isLoggedIn;
    if (isGoogleSignedIn || isFacebookSignedIn)
      return true;
    else
      return false;
  }

  Future<Null> support(String message) async {
    UserInformation userInformation = await getUserInfo();
    Support support = Support(
      name: userInformation.name,
      email: userInformation.email,
      message: message,
    );
    await client.createSupport(support);
  }

  Future<UserInformation> updateInfo(String name, String imageUrl) {
    UpdateUserRequest updateUserRequest = UpdateUserRequest(name, imageUrl);
    Map<String, dynamic> updateUserRequestMap = updateUserRequest.toJson();
    updateUserRequestMap.removeWhere((key, value) => value == null);
    return client.updateUser(updateUserRequestMap);
  }

  Future<UserInformation> updateNotificationId() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var playerId = status.subscriptionStatus.userId;
    Map<String, dynamic> updateUserRequestMap =
        Notification("{\"customer\":\"$playerId\"}").toJson();
    return client.updateUser(updateUserRequestMap);
  }

  Future<void> otpSend(
      String phoneNumberFull, VerificationCallbacks verificationCallback) {
    return _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumberFull,
      verificationCompleted: (PhoneAuthCredential credential) {
        if (Platform.isAndroid) {
          verificationCallback.onCodeVerifying();
          _fireSignIn(credential, verificationCallback);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print("FirebaseAuthException: $e");
        print("FirebaseAuthException_message: ${e.message}");
        print("FirebaseAuthException_code: ${e.code}");
        print("FirebaseAuthException_phoneNumber: ${e.phoneNumber}");
        verificationCallback.onCodeSendError();
      },
      codeSent: (String verificationId, int resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        verificationCallback.onCodeSent();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  otpVerify(String otp, VerificationCallbacks verificationCallback) {
    _fireSignIn(
        PhoneAuthProvider.credential(
            verificationId: _verificationId, smsCode: otp),
        verificationCallback);
  }

  _fireSignIn(AuthCredential credential,
      VerificationCallbacks verificationCallback) async {
    try {
      await _firebaseAuth.signInWithCredential(credential);
      var user = _firebaseAuth.currentUser;
      var idToken = await user.getIdToken();

      final loggedInResponse = await signInWithPhoneNumber(idToken);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', loggedInResponse.token);
      await saveUser(loggedInResponse.userInfo);
      await updateNotificationId();

      verificationCallback.onCodeVerified(loggedInResponse);
    } catch (e) {
      print("signInWithCredential: $e");
      String errorToReturn = "something_wrong";
      if (e is DioError) {
        //signout of social accounts.
        try {
          logout();
        } catch (le) {
          print(le);
        }
        if ((e).response != null) {
          Map<String, dynamic> errorResponse = (e).response.data;
          if (errorResponse.containsKey("message")) {
            String errorMessage = errorResponse["message"] as String;
            print("errorMessage: $errorMessage");
            if (errorMessage.toLowerCase().contains("role")) {
              errorToReturn = "role_exists";
            }
          }
        }
      }
      verificationCallback.onCodeVerificationError(errorToReturn);
    }
  }
}
