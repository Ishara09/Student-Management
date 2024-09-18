class Courses {
  final int? id;
  final String name;
  final int? price;

  Courses({
    required this.id,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(id: json['id'], name: json['name'], price: json['price']);
  }
  @override
  String toString() {
    return 'Course(id: $id, coursename: $name, price: $price)';
  }
}
