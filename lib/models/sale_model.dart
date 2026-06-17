class SaleModel {
  String? id;
  String name;
  String description;
   
  SaleModel({
    this.id,
    required this.name,
    required this.description,
  });

  factory SaleModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return SaleModel(
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