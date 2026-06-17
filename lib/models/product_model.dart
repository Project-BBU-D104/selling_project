class ProductModel {
  String? id;
  String name;
  double costPrice;
  double salePrice;
  int quantity;
  String? description;
  bool status;
  Map<String, dynamic> category;
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();
   
  ProductModel({
    this.id,
    required this.name,
    required this.costPrice,
    required this.salePrice,
    required this.category,
    required this.quantity,
    this.description,
    this.status = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return ProductModel(
      id: id,
      name: json['name'] ?? '',
      costPrice: (json['cost_price'] ?? 0).toDouble(),
      salePrice: (json['sale_price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      description: json['description'] ?? '',
      category: json['category'] ?? {},
      status: json['status'] ?? true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "cost_price": costPrice,
      "sale_price": salePrice,
      "quantity": quantity,
      "description": description,
      "category": category,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt
    };
  }
}