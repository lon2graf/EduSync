class EducationHeadModel {
  final int? id;
  final String name;
  final String? surname;
  final String? patronymic;
  final String? email;
  final String? password;
  final int institutionId;

  EducationHeadModel({
    this.id,
    required this.name,
    this.surname,
    this.patronymic,
    this.email,
    this.password,
    required this.institutionId,
  });

  factory EducationHeadModel.fromJson(Map<String, dynamic> json) {
    return EducationHeadModel(
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
      if (id != null) 'id': id,
      'name': name,
      'surname': surname,
      'patronymic': patronymic,
      'email': email,
      'password': password,
      'institution_id': institutionId,
    };
  }
}
