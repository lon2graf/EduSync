class UsingRequestModel {
  final int? id;
  final String institutionName;
  final String address;
  final String surname;
  final String name;
  final String? patronymic;
  final String email;
  final bool? isAccepted;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;

  UsingRequestModel({
    this.id,
    required this.institutionName,
    required this.address,
    required this.surname,
    required this.name,
    this.patronymic,
    required this.email,
    this.isAccepted,
    this.submittedAt,
    this.reviewedAt,
  });

  factory UsingRequestModel.fromJson(Map<String, dynamic> json) {
    return UsingRequestModel(
      id: json['id'] as int,
      institutionName: json['institution_name'] as String,
      address: json['address'] as String,
      surname: json['surname'] as String,
      name: json['name'] as String,
      patronymic: json['patronymic'] as String?,
      email: json['email'] as String,
      isAccepted: json['isAccepted'] as bool,
      submittedAt: DateTime.parse(json['submitted_at']),
      reviewedAt:
          json['reviewed_at'] != null
              ? DateTime.parse(json['reviewed_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'institution_name': institutionName,
      'address': address,
      'surname': surname,
      'name': name,
      'patronymic': patronymic,
      'email': email,
      'isAccepted': isAccepted,
      'submitted_at': submittedAt?.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
    };
    // Добавляем id только если он не null
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
