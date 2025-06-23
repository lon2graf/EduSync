class SubjectModel {
  final int? id;
  final String name;
  final int instituteId;

  SubjectModel({this.id, required this.name, required this.instituteId});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as int,
      name: json['name'] as String,
      instituteId: json['institute_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'institute_id': instituteId,
    };
  }
}
