class Student {
  final int id;
  final String name;
  final String surname;
  final String? patronymic;
  final String email;
  final String password;
  final String groupName;
  final String? speciality;
  final int instituteId;

  Student({
    required this.id,
    required this.name,
    required this.surname,
    this.patronymic,
    required this.email,
    required this.password,
    required this.groupName,
    this.speciality,
    required this.instituteId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'] as String,
      surname: json['surname'] as String,
      patronymic: json['patronymic'],
      email: json['email'] as String,
      password: json['password'] as String,
      groupName: json['group_name'] as String,
      speciality: json['speciality'],
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
      'group_name': groupName,
      'speciality': speciality,
      'institute_id': instituteId,
    };
  }
}
