import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quick_bite/app.dart';
import 'package:quick_bite/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  // // Initialize sqflite database factory for Desktop/Windows
  // if (Platform.isWindows ) {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;
  // }
  runApp(const QuickBite());
}
