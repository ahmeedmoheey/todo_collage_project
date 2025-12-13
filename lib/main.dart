import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_collage_project/provider/provider.dart';
import 'my_application/my_application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyAWPmeoYcSqlRW7_ElmNDRsP07ec7UwMLs',
        appId: 'com.example.todo_collage_project',
        messagingSenderId: '913037675440',
        projectId: 'todo-collage-project'),
  );
  await FirebaseFirestore.instance.enableNetwork();
  runApp(ChangeNotifierProvider(
      create:(context) => SettingsProvider(),

      child: MyApp()));
}