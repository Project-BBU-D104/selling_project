class UserModel {
  String? id;
  String name;
  String description;
   
  UserModel({
    this.id,
    required this.name,
    required this.description,
  });

  factory UserModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return UserModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "description": description,
    };
  }
}