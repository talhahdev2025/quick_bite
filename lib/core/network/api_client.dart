import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quick_bite/core/network/api_constants.dart';
import 'package:quick_bite/core/network/api_exception.dart';

class ApiClient {
  Future<dynamic> get({required String endpoint}) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
    );
    if (response.isSuccessful) {
      final body = jsonDecode(response.body);
      return body;
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: 'Something went Wrong',
    );
  }
}

extension ApiExtension on http.Response {
  bool get isSuccessful {
    return statusCode >= 200 && statusCode <= 300;
  }
}
