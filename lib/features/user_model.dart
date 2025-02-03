class UserModel {
  final String name;
  final String dob;
  final int colorIndex;

  UserModel({
    required this.name,
    required this.dob,
    required this.colorIndex,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      dob: json['dob'],
      colorIndex: json['colorIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dob': dob,
      'colorIndex': colorIndex,
    };
  }
}
