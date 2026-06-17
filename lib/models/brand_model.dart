class BrandModel {
  String? id;
  String name;
  String description;
   
  BrandModel({
    this.id,
    required this.name,
    required this.description,
  });

  factory BrandModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return BrandModel(
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