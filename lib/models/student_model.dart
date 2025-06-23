class StudentModel {
  final int? id;
  final String name;
  final String surname;
  final String? patronymic;
  final String email;
  final String password;
  final int groupId;

  StudentModel({
    required this.id,
    required this.name,
    required this.surname,
    this.patronymic,
    required this.email,
    required this.password,
    required this.groupId,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      surname: json['surname'] as String,
      patronymic: json['patronymic'] as String?,
      email: json['email'] as String,
      password: json['password'] as String,
      groupId: json['group_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'surname': surname,
      'patronymic': patronymic,
      'email': email,
      'password': password,
      'group_id': groupId,
    };
  }
}
