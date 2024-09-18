import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/student_provier.dart';
import 'student_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StudentProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management',
      home: StudentListScreen(),
    );
  }
}
