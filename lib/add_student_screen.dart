import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/courses.dart';
import 'package:student_management/student_service.dart';
import 'student.dart';
import 'student_provier.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _age;
  String? _address;

  String? _course;
  List<String> _selectedGenders = [];
  List<String> _courses = [];
  final StudentService _studentService = StudentService();

  final StudentProvider _studentProvider = StudentProvider();
  @override
  void initState() {
    super.initState();
    fetchAndSetCourses();
    print("Add Student Screen");
  }

  // Future<void> fetchAndSetCourses() async {
  //   try {
  //     List<Courses> coursesList = await _studentService.fetchcourses();
  //     print(coursesList.toString());
  //     _courses.clear();
  //     _courses.addAll(coursesList.map((course) => course.name).toList());
  //     print("$_course + Hello here is the data");
  //     print('Courses fetched and set: $_courses');
  //   } catch (error) {
  //     print('Failed to load courses: $error');
  //   }
  // }

  Future<void> fetchAndSetCourses() async {
    try {
      List<String> coursesList =
          (await _studentService.fetchcourses()).cast<String>();

      _courses.addAll(coursesList.map((course) => course).toList());
      debugPrint("Hello, here is the data:");
    } catch (error) {
      debugPrint('Failed to load courses: $error');
    }
  }

  // final List<String> _courses = [
  //   'Mathematics',
  //   'Computer Science',
  //   'Physics',
  //   'Chemistry',
  //   'Biology'
  // ];

  bool isMaleSelected = false;
  bool isFemaleSelected = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 24),
              _buildTextField(
                label: 'Name',
                onSaved: (value) => _name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the student\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Age',
                keyboardType: TextInputType.number,
                onSaved: (value) => _age = int.tryParse(value!),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Address',
                onSaved: (value) => _address = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildCheckboxField(
                label: 'Gender',
                values: ['Male', 'Female', 'Other'],
                selectedValues: _selectedGenders,
                onChanged: (selected) {
                  setState(() {
                    if (_selectedGenders.contains(selected)) {
                      _selectedGenders.remove(selected);
                    } else {
                      _selectedGenders = [selected!];
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Course',
                value: _course,
                items: [
                  'Mathematics',
                  'Computer Science',
                  'Physics',
                  'Chemistry',
                  'Biology'
                ],
                onChanged: (value) {
                  setState(() {
                    _course = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedGenders == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select a gender')),
                        );
                        return;
                      }
                      _formKey.currentState!.save();
                      final student = Student(
                        name: _name!,
                        age: _age!,
                        address: _address!,
                        gender: _selectedGenders.first,
                        course: _course!,
                      );
                      Provider.of<StudentProvider>(context, listen: false)
                          .addStudent(student);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 8,
                    backgroundColor: theme.primaryColor,
                    shadowColor: Colors.grey.shade400,
                  ),
                  child: Text(
                    'Add Student',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildCheckboxField({
    required String label,
    required List<String> values,
    required List<String> selectedValues,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10.0,
          children: values.map((value) {
            return FilterChip(
              label: Text(value),
              selected: selectedValues.contains(value),
              onSelected: (isSelected) {
                onChanged(isSelected ? value : null);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
