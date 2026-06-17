class PaymentModel {
  String? id;
  String name;
  String description;
   
  PaymentModel({
    this.id,
    required this.name,
    required this.description,
  });

  factory PaymentModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return PaymentModel(
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