class ProductModel {
  String? id;
  String name;
  double price;
  String categoryId;
   
  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.categoryId,
  });

  factory ProductModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return ProductModel(
      id: id,
      name: json['name'] ?? '',
      price: json['price'] ?? 0.0,
      categoryId: json['categoryId'] ?? '',
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "price": price,
      "categoryId": categoryId,
    };
  }
}