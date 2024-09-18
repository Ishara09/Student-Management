class Student {
  final int? id;
  final String name;
  final int age;
  final String address;
  final String gender;
  final String course;

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.address,
    required this.gender,
    required this.course,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'address': address,
      'gender': gender,
      'course': course,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      address: json['address'],
      gender: json['gender'],
      course: json['course'],
    );
  }
}
