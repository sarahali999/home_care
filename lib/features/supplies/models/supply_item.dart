enum SupplyPurchaseType { buy, rent }

class SupplyItem {
  final String id;
  final String name;
  final String description;
  final double buyPrice;
  final double rentPricePerDay;
  final int availableQuantity;

  const SupplyItem({
    required this.id,
    required this.name,
    required this.description,
    required this.buyPrice,
    required this.rentPricePerDay,
    required this.availableQuantity,
  });
}

