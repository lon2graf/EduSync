class EducationHead {
  final int id;
  final String name;
  final String? surname;
  final String? patronymic;
  final String? email;
  final String? password;
  final int institutionId;

  EducationHead({
    required this.id,
    required this.name,
    this.surname,
    this.patronymic,
    this.email,
    this.password,
    required this.institutionId,
  });

  factory EducationHead.fromJson(Map<String, dynamic> json) {
    return EducationHead(
      id: json['id'] as int,
      name: json['name'] as String,
      surname: json['surname'],
      patronymic: json['patronymic'],
      email: json['email'],
      password: json['password'],
      institutionId: json['institution_id'] as int,
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
      'institution_id': institutionId,
    };
  }
}
