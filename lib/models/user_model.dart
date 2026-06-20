class UserModel {
  String? uid;
  String? username;
  String? email;

  UserModel({
    this.uid,
    this.username,
    this.email,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
    };
  }
}