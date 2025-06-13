class Teacher {
  final int id;
  final String name;
  final String surname;
  final String? patronymic;
  final String email;
  final String password;
  final String? department;
  final int instituteId;

  Teacher({
    required this.id,
    required this.name,
    required this.surname,
    this.patronymic,
    required this.email,
    required this.password,
    this.department,
    required this.instituteId,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as int,
      name: json['name'] as String,
      surname: json['surname'] as String,
      patronymic: json['patronymic'],
      email: json['email'] as String,
      password: json['password'] as String,
      department: json['department'],
      instituteId: json['institute_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'patronymic': patronymic,
      'email': email,
      'password': password,
      'department': department,
      'institute_id': instituteId,
    };
  }
}

