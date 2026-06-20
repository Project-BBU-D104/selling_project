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
      status: json['status'] ?? true,
     createdAt: json['created_at'] != null
    ? DateTime.parse(json['created_at'])
    : null,
      updatedAt: json['updated_at'] != null
    ? DateTime.parse(json['updated_at'])
    : null,
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "description": description,
      "status": status,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}