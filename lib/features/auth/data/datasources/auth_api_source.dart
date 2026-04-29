import 'package:dio/dio.dart';
import 'package:mind_feed/core/database/api/api_consumer.dart';
import 'package:mind_feed/core/database/api/end_ponits.dart';
import 'package:mind_feed/core/errors/expentions.dart';
import 'package:mind_feed/core/params/login_params.dart';
import 'package:mind_feed/core/params/signup_params.dart';

class AuthApiSource {
  final ApiConsumer apiConsumer;
  AuthApiSource({required this.apiConsumer});

  Future<String> login({required LoginParams params}) async {
    final response = await apiConsumer.post(
      EndPoint.loginUrl,
      data: params.toJson(),
      isFormData: false,
    );
    Map<String, dynamic> jsonData = response.data;
    return jsonData["idToken"];
  }

  Future<Response<dynamic>> signUp({required SignupParams params}) async {
    final signUpResponse = await apiConsumer.post(
      EndPoint.signUpUrl,
      data: params.toSignUpJson(),
      isFormData: false,
    );

    final responseData = signUpResponse.data;
    if (params.displayName.trim().isEmpty || responseData is! Map) {
      return signUpResponse;
    }

    final responseMap = Map<String, dynamic>.from(responseData as Map);
    final idToken = responseMap['idToken'] as String?;
    if (idToken == null || idToken.isEmpty) {
      return signUpResponse;
    }

    try {
      return await apiConsumer.post(
        EndPoint.updateDisplayName,
        data: params.toUpdateDisplayNameJson(idToken: idToken),
        isFormData: false,
      );
    } on ServerException {
      return signUpResponse;
    }
  }
}
