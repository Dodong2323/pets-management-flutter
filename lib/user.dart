// user.dart
class User {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String username;
  final String password;
  final String email;
  final String phone;
  final String address;
  final String profilePicture;
  final String createdAt;

  User({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
    required this.address,
    required this.profilePicture,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      profilePicture: json['profile_picture'] ?? '',
      createdAt: json['created_at'],
    );
  }
}
