class UserModel {
  final String? id;
  final String fullName;
  final String? email;
  final String? phone;
  final String password;
  final String role;
  final bool status;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    required this.fullName,
    this.email,
    this.phone,
    required this.password,
    required this.role,
    this.status = true,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      password: json['password'] ?? '',
      role: json['role'] ?? 'Staff',
      status: json['status'] is bool
          ? json['status']
          : (json['status'] == 1 || json['status'] == 'true'),
      imageUrl: json['image_url'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
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
      'status': status,
      'image_url': imageUrl,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
