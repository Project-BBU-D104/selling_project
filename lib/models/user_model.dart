class UserModel {
  String? uid;
  String? username;
  String? email;
  String? role;
  String? department;
  bool status;
  String? photoUrl;

  UserModel({
    this.uid,
    this.username,
    this.email,
    this.role,
    this.department,
    this.status = true,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['id'] ?? json['uid'],
      username: json['username'],
      email: json['email'],
      role: json['role'] ?? 'Staff',
      department: json['department'] ?? '',
      status: json['status'] ?? true,
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'role': role,
      'department': department,
      'status': status,
      'photoUrl': photoUrl,
    };
  }
}