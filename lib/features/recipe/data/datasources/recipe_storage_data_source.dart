import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class RecipeStorageDataSource {
  // final FirebaseStorage _storage;

  // RecipeStorageDataSource({FirebaseStorage? storage})
  //   : _storage = storage ?? FirebaseStorage.instance;

  // Future<String> uploadRecipeImage(File imageFile, String userId) async {
  //   final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  //   final ref = _storage.ref().child('recipe_image/$userId/$fileName');

  //   final uploadTask = await ref.putFile(imageFile);
  //   return await uploadTask.ref.getDownloadURL();
  // }

  static const String _apiKey = String.fromEnvironment('IMGBB_API_KEY');

  Future<String> uploadRecipeImage(File imageFile, String userId) async {
    if (_apiKey.isEmpty) {
      throw Exception('Imgbb API key is missing! ');
    }

    final url = Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['data']['url'] as String;
    } else {
      throw Exception(
        'Failed to upload image to imgBB (status code: ${response.statusCode}) : ${response.body}',
      );
    }
  }

  Future<void> deleteOldImage(String? deleteUrl) async {
  if (deleteUrl == null || deleteUrl.isEmpty) return;

  try {
    // ImgBB delete_url can be triggered via HTTP GET
    await http.get(Uri.parse(deleteUrl));
  } catch (e) {
    // Log error, but don't block the main upload flow
    debugPrint('Failed to delete old image: $e');
  }
}
}
