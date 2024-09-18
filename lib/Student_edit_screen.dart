import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/student.dart';
import 'package:student_management/student_provier.dart';

class EditStudentScreen extends StatefulWidget {
  final Student student;

  EditStudentScreen({required this.student});

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _age;
  late String _address;
  List<String> _selectedGenders = [];
  late String _course;

  @override
  void initState() {
    super.initState();
    _name = widget.student.name;
    _age = widget.student.age;
    _address = widget.student.address;
    _selectedGenders = [widget.student.gender];
    _course = widget.student.course;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Student'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 24),
              _buildTextField(
                label: 'Name',
                initialValue: _name,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Age',
                initialValue: _age.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) => _age = int.tryParse(value!) ?? _age,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Address',
                initialValue: _address,
                onSaved: (value) => _address = value!,
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
                      _formKey.currentState!.save();
                      Provider.of<StudentProvider>(context, listen: false)
                          .updateStudent(
                        Student(
                          id: widget.student.id,
                          name: _name,
                          age: _age,
                          address: _address,
                          gender:
                              _selectedGenders.first, // Save selected gender
                          course: _course,
                        ),
                      );
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
                  child: Text('Save Changes',
                      style: TextStyle(fontSize: 15, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      initialValue: initialValue,
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
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
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
