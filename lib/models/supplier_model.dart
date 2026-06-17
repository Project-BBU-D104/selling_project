class SupplierModel {
  String? id;
  String name;
  String phone;
  String email;
  String? address = '';
  SupplierModel({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.address = '',
  });

  factory SupplierModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return SupplierModel(
      id: id,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "address": address,
    };
  }
}