class GroupModel {
  final int? id; // может быть null, если группа ещё не создана в БД
  final String name;
  final int? instituteId;

  GroupModel({this.id, required this.name, this.instituteId});

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json['id'] as int?,
    name: json['name'] as String,
    instituteId:
        json['institute_id'] != null ? json['institute_id'] as int : null,
  );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{'name': name, 'institute_id': instituteId};
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
