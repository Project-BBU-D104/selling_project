class DashboardKpiModel {
  final double totalSales;
  final double totalPurchases;
  final int totalProducts;
  final int totalCustomers;
  final int totalSuppliers;
  final int lowStockAlerts;

  DashboardKpiModel({
    required this.totalSales,
    required this.totalPurchases,
    required this.totalProducts,
    required this.totalCustomers,
    required this.totalSuppliers,
    required this.lowStockAlerts,
  });

  factory DashboardKpiModel.fromJson(Map<String, dynamic> json) {
    return DashboardKpiModel(
      totalSales: (json['total_sales'] ?? 0).toDouble(),
      totalPurchases: (json['total_purchases'] ?? 0).toDouble(),
      totalProducts: json['total_products'] ?? 0,
      totalCustomers: json['total_customers'] ?? 0,
      totalSuppliers: json['total_suppliers'] ?? 0,
      lowStockAlerts: json['low_stock_alerts'] ?? 0,
    );
  }
}