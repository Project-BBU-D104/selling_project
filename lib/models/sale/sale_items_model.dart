class SaleItemModel {
  String? id;
  String productId;
  String productName;
  String? brandId;
  String? brandName;
  int quantity;
  double unitPrice;
  double totalPrice;
  String? imageUrl;

  SaleItemModel({
    this.id,
    required this.productId,
    required this.productName,
    this.brandId,
    this.brandName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.imageUrl,
  });

  factory SaleItemModel.fromProduct(Map<String, dynamic> product, int qty) {
    double price = (product["sale_price"] ?? product["price"] ?? 0).toDouble();
    return SaleItemModel(
      productId: product["id"] ?? "",
      productName: product["product_name"] ?? product["name"] ?? "",
      brandId: product["brand_id"],
      brandName: product["brand_name"],
      quantity: qty,
      unitPrice: price,
      totalPrice: price * qty,
      imageUrl: product["image"] ?? product["image_url"],
    );
  }

  factory SaleItemModel.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    return SaleItemModel(
      id: id,
      productId: json["product_id"] ?? "",
      productName: json["product_name"] ?? "",
      brandId: json["brand_id"] ?? json["categoryId"],
      brandName: json["brand_name"] ?? json["categoryName"],
      quantity: json["quantity"] ?? 0,
      unitPrice: (json["unit_price"] ?? 0).toDouble(),
      totalPrice: (json["total_price"] ?? 0).toDouble(),
      imageUrl: json["image_url"] ?? json["image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "product_name": productName,
      "brand_id": brandId ?? "",
      "brand_name": brandName ?? "N/A",
      "quantity": quantity,
      "unit_price": unitPrice,
      "total_price": totalPrice,
      "image_url": imageUrl ?? "",
    };
  }
}