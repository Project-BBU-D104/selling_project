class BrandModel {
  String? id;
  String name;
  String description;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  BrandModel({
    this.id,
    required this.name,
    required this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BrandModel.fromJson(
    Map<String, dynamic> json,
    String? id,
  ) {
    return BrandModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? true,
      createdAt: json['created_at']?.toDate(),
      updatedAt: json['updated_at']?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}