import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/student_provier.dart';
import 'student_edit_screen.dart';
import 'add_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Student Management'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                // labelText: 'Search by Name',
                hintText: "Search by Name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<StudentProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final students = provider.searchStudents(_searchQuery);

                if (students.isEmpty) {
                  return Center(
                    child: Text(
                      'No Students Found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: students.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          'Course: ${student.course}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueGrey),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditStudentScreen(student: student),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () {
                                provider.deleteStudent(student.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentScreen()),
          );
        },
        backgroundColor: theme.primaryColor,
        elevation: 5,
        child: const Icon(Icons.add),
      ),
    );
  }
}
