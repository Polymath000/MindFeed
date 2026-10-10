import 'package:dio/dio.dart';
import 'package:mind_feed/core/database/api/api_consumer.dart';
import 'package:mind_feed/core/database/api/end_ponits.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/core/params/signup_params.dart';

class AuthApiSource {
  final ApiConsumer? apiConsumer;
  AuthApiSource({this.apiConsumer});

  Future<String> login({required LoginParams params}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return 'mock_token_${params.email.hashCode.abs()}';
  }

  Future<Response<dynamic>> signUp({required SignupParams params}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return Response(
      requestOptions: RequestOptions(path: EndPoint.signUpUrl),
      data: <String, dynamic>{
        'idToken': 'mock_token_${params.email.hashCode.abs()}',
        'email': params.email,
        'displayName': params.displayName,
      },
      statusCode: 200,
    );
  }
}
