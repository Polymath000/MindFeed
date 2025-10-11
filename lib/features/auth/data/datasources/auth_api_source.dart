import 'package:mind_feed/core/database/api/api_consumer.dart';
import 'package:mind_feed/core/database/api/end_ponits.dart';
import 'package:mind_feed/core/params/login_params.dart';

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
    return jsonData["idToken"] ?? "";
  }
}
