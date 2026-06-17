class CategoryModel {
  String? id;
  String name;
  String description;
   
  CategoryModel({
    this.id,
    required this.name,
    required this.description,
  });

  factory CategoryModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return CategoryModel(
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