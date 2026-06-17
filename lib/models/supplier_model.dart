class SupplierModel {
  String? id;
  String name;
  String? contactPerson;
  String phone;
  String email;
  String? companyName;
  bool status = true;
  String? address = '';
  DateTime? createdAt;
  DateTime? updatedAt;

  SupplierModel({ 
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.address = '',
    this.contactPerson = '',
    this.companyName = '',
    this.status = true,
    this.createdAt,
    this.updatedAt
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
      contactPerson: json['contact_person'] ?? '',
      companyName: json['company_name'] ?? '',
      status: json['status'] ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "address": address,
      "contact_person": contactPerson,
      "company_name": companyName,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt
    };
  }
}