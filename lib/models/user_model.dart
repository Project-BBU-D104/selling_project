class UserModel {
  final String? id;
  final String fullName;
  final String? email;
  final String? phone;
  final String password;
  final String? department;
  final String role;
  final bool status;

  UserModel({
    this.id,
    required this.fullName,
    this.email,
    this.phone,
    this.department,
    required this.password,
    required this.role,
    this.status = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      password: json['password'] ?? '',
      role: json['role'] ?? 'Staff',
      department: json['department'],
      status: json['status'] is bool
          ? json['status']
          : (json['status'] == 1 || json['status'] == 'true'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
      'department': department ?? 'Operations',
      'status': status,
    };
  }
}
