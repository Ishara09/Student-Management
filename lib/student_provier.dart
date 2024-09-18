import 'package:flutter/material.dart';
import 'package:student_management/courses.dart';
import 'package:student_management/student.dart';
import 'student_service.dart';

class StudentProvider extends ChangeNotifier {
  final StudentService _studentService = StudentService();
  List<Student> _students = [];
  List<Courses> _courses = [];
  bool _isLoading = false;

  List<Student> get students => _students;
  bool get isLoading => _isLoading;

  StudentProvider() {
    fetchStudents();
    fetchCourses();
  }

  Future<void> fetchStudents() async {
    _students = await _studentService.fetchStudents();
    _students = _students..sort((a, b) => b.id!.compareTo(a.id!));
    notifyListeners();
  }

  Future<void> fetchCourses() async {
    _courses = await _studentService.fetchcourses();
    notifyListeners();
    // print(_courses.first);
  }

  // // Fetch all students
  // Future<void> fetchStudents() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     _students = await _studentService.fetchStudents();
  //   } catch (error) {
  //     // Handle error (e.g., show an error message)
  //     print('Error fetching students: $error');
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Add a new student
  Future<void> addStudent(Student student) async {
    print(student.name);
    print(student.address);
    print(student.course);
    print(student.age);

    try {
      await _studentService.addStudent(student);
      _students.add(student);
      notifyListeners();
    } catch (error) {
      print('Error adding student: $error');
    }
  }

  // Update an existing student
  Future<void> updateStudent(Student student) async {
    try {
      await _studentService.updateStudent(student);
      final index = _students.indexWhere((s) => s.id == student.id);
      if (index != -1) {
        _students[index] = student;
        notifyListeners();
      }
    } catch (error) {
      print('Error updating student: $error');
    }
  }

  // Delete a student
  Future<void> deleteStudent(int id) async {
    try {
      await _studentService.deleteStudent(id);
      _students.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (error) {
      print('Error deleting student: $error');
    }
  }

  List<Student> searchStudents(String query) {
    if (query.isEmpty) {
      return _students;
    } else {
      return _students
          .where((student) =>
              student.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
