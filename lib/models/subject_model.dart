class Subject {
  final int id;
  final String name;
  final String? speciality;
  final String hours;
  final int semester;

  Subject({
    required this.id,
    required this.name,
    this.speciality,
    required this.hours,
    required this.semester,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as int,
      name: json['name'] as String,
      speciality: json['speciality'],
      hours: json['hours'] as String,
      semester: json['semester'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'speciality': speciality,
      'hours': hours,
      'semester': semester,
    };
  }
}
