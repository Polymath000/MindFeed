import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:mind_feed/core/database/api/api_consumer.dart';
import 'package:mind_feed/core/database/api/end_ponits.dart';
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

  Future<Response> signUp({required SignupParams params}) async {
    final response = await apiConsumer.post(
      EndPoint.signUpUrl,
      data: params.toJson(),
      isFormData: false,
    );
    // final firestore = FirebaseFirestore.instance;
    // firestore.collection('users');
    return response;
  }
}
