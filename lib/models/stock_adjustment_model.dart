class StockAdjustmentModel {
  String? id;
  String name;
  String description;
   
  StockAdjustmentModel({
    this.id,
    required this.name,
    required this.description,
  });

  factory StockAdjustmentModel.fromJson(
      Map<String,dynamic> json,
      String? id
  ){
    return StockAdjustmentModel(
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