class CustomerModel {
  String? id;
  String customerName;
  String phone;
  String email;
  String? address;
  bool? status;
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  CustomerModel({
    this.id,
    required this.customerName,
    required this.phone,
    required this.email,
    this.address,
    this.status,
    this.createdAt,
    this.updatedAt
  });

  factory CustomerModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return CustomerModel(
      id: id,
      customerName: json['customer_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "customer_name": customerName,
      "phone": phone,
      "email": email,
      "address": address,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt
    };
  }
}