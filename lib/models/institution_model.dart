class Institution {
  final int id;
  final String name;
  final String address;
  final String? email;

  Institution({
    required this.id,
    required this.name,
    required this.address,
    this.email,
  });

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'address': address, 'email': email};
  }
}
