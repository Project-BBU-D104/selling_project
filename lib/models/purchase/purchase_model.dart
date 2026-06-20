class PurchaseModel {
  String? id;
  String name;
  String supplierId;
  String invoiceNo;
  int totalAmount;
  DateTime purchaseDate = DateTime.now();
  bool status = true;
  
   
  PurchaseModel({
    this.id,
    required this.name,
    required this.supplierId,
    required this.invoiceNo,
    required this.totalAmount,
    required this.purchaseDate,
    this.status = true
  });

  factory PurchaseModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return PurchaseModel(
      id: id,
      name: json['name'] ?? '',
      supplierId: json['supplier_id'] ?? '',
      invoiceNo: json['invoice_no'] ?? '',
      totalAmount: json['total_amount'] ?? 0,
      purchaseDate: json['purchase_date'] != null
    ? json['purchase_date'].toDate()
    : DateTime.now(),
      status: json['status'] ?? true
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "supplier_id": supplierId,
      "invoice_no": invoiceNo,
      "total_amount": totalAmount,
      "purchase_date": purchaseDate,
      "status": status
    };
  }
}