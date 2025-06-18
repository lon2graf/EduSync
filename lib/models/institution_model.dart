class InstitutionModel {
  final int? id;
  final String name;
  final String address;

  InstitutionModel({this.id, required this.name, required this.address});

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'name': name, 'address': address};
  }
}
