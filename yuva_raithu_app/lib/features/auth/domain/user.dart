class User {
  final int id;
  final String phoneNumber;
  final String email;
  final String fullName;
  final List<String> roles;

  User({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.fullName,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'fullName': fullName,
      'roles': roles,
    };
  }
}
