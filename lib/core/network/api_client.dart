import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:quick_bite/core/network/api_constants.dart';
import 'package:quick_bite/core/network/api_exception.dart';

class ApiClient {
  Future<dynamic> get({required String endpoint}) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
          )
          .timeout(const Duration(seconds: 15));

      if (response.isSuccessful) {
        final dynamic body = jsonDecode(response.body);
        return body;
      }

      throw ApiException(
        statusCode: response.statusCode,
        message: 'Request failed with status code ${response.statusCode}',
      );
    } on SocketException {
      throw const ApiException(
        statusCode: 0,
        message: 'No internet connection. Please check your network.',
      );
    } on TimeoutException {
      throw const ApiException(
        statusCode: 408,
        message: 'Connection timed out. Please try again later.',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        statusCode: 500,
        message: e.toString(),
      );
    }
  }
}

extension ApiExtension on http.Response {
  bool get isSuccessful {
    return statusCode >= 200 && statusCode < 300;
  }
}

