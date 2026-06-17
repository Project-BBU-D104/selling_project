class CategoryModel {
  String? id;
  String name;
  String description;
  bool status;
  DateTime? createdAt;
  DateTime? updatedAt;
   
  CategoryModel({
    this.id,
    required this.name,
    required this.description,
    this.status = true,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return CategoryModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "description": description,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}