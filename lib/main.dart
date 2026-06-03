import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sigaram_technologies_internship_assignment/app/main_app.dart';
import 'package:sigaram_technologies_internship_assignment/core/local_storage_service.dart';
import 'package:sigaram_technologies_internship_assignment/core/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorageService.init();
  await ServiceLocator.init();
  runApp(const MainApp());
}
