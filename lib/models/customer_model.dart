class CustomerModel {
  String? id;
  String name;
  String phone;
  String email;
  CustomerModel({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory CustomerModel.fromJson(
      Map<String,dynamic> json,
      String id
  ){
    return CustomerModel(
      id: id,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "phone": phone,
      "email": email,
    };
  }
}