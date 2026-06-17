class PaymentModel {
  String? id;
  String name;
  String description;
  Map<String,dynamic> sale;
  String paymentMethod;
  double amount;
  String referenceNo;
  DateTime paymentDate;
  DateTime? createdAt;
  DateTime? updatedAt;
   
  PaymentModel({
    this.id,
    required this.name,
    required this.description,
    required this.sale,
    required this.paymentMethod,
    required this.amount,
    required this.referenceNo,
    required this.paymentDate,
    this.createdAt,
    this.updatedAt
  });

  factory PaymentModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return PaymentModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      sale: json['sale'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      amount: json['amount'] ?? 0.0,
      referenceNo: json['reference_no'] ?? '',
      paymentDate: json['payment_date'] ?? DateTime.now(),
      createdAt: json['created_at'] ?? DateTime.now(),
      updatedAt: json['updated_at'] ?? DateTime.now(),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "description": description,
      "sale": sale,
      "payment_method": paymentMethod,
      "amount": amount,
      "reference_no": referenceNo,
      "payment_date": paymentDate
    };
  }
}