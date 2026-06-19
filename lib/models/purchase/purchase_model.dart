class PurchaseModel {
  String? id;
  String name;
  String description;
   
  PurchaseModel({
    this.id,
    required this.name,
    required this.description,
  });

  factory PurchaseModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return PurchaseModel(
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