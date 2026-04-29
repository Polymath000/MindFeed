class ErrorModel {
  final int status;
  final String errorMessage;

  ErrorModel({required this.status, required this.errorMessage});

  factory ErrorModel.fromJson(dynamic jsonData) {
    if (jsonData is Map) {
      final data = Map<String, dynamic>.from(jsonData);
      final nestedError = data['error'];

      if (nestedError is Map) {
        final error = Map<String, dynamic>.from(nestedError);
        return ErrorModel(
          status: _asInt(error['code']) ?? _asInt(data['status']) ?? 0,
          errorMessage:
              _asString(error['message']) ??
              _asString(data['message']) ??
              _asString(data['Message']) ??
              _asString(data['errorMessage']) ??
              'Unexpected error',
        );
      }

      return ErrorModel(
        status: _asInt(data['status']) ?? _asInt(data['code']) ?? 0,
        errorMessage:
            _asString(data['message']) ??
            _asString(data['Message']) ??
            _asString(data['errorMessage']) ??
            'Unexpected error',
      );
    }

    return ErrorModel(
      status: 0,
      errorMessage: jsonData?.toString() ?? 'Unexpected error',
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '');
  }

  static String? _asString(dynamic value) {
    final text = value?.toString();
    if (text == null || text.isEmpty) {
      return null;
    }
    return text;
  }
}
