import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:student_management/courses.dart';
import 'package:student_management/student.dart';

class StudentService {
  // final url = Uri.parse('http://172.20.10.2/api/students');
  final String baseUrl = "http://172.20.10.2:8080/api/students";

  // Fetch all students from the backend
  // Future<List<Student>> fetchStudents() async {
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => Student.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load students');
  //   }
  // }

  Future<List<Student>> fetchStudents() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Student.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<List<Courses>> fetchcourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // print(data);
      return data.map((item) => Courses.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Courses');
    }
  }

  Future<void> addStudent(Student student) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(student.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add employee');
    }
  }

  // Future<void> addStudent(Student student) async {
  //   final response = await http.post(
  //     Uri.parse(baseUrl),
  //     headers: {"Content-Type": "application/json"},
  //     body: json.encode(student.toString()), // This causes the error
  //   );

  //   if (response.statusCode != 201) {
  //     throw Exception('Failed to add student');
  //   }
  // }

  // Update a student on the backend
  Future<void> updateStudent(Student student) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${student.id}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(student.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update student');
    }
  }

  // Delete a student from the backend
  Future<void> deleteStudent(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete student');
    }
  }
}
