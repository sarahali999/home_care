import 'package:flutter/foundation.dart';

import '../../../core/models/order_status.dart';
import '../models/supply_item.dart';

class SuppliesViewModel extends ChangeNotifier {
  final List<SupplyItem> _items = const [
    SupplyItem(
      id: 's1',
      name: 'جهاز قياس ضغط',
      description: 'جهاز رقمي لقياس ضغط الدم',
      buyPrice: 25.0,
      rentPricePerDay: 2.0,
      availableQuantity: 8,
    ),
    SupplyItem(
      id: 's2',
      name: 'كرسي متحرك',
      description: 'كرسي متحرك قابل للطي',
      buyPrice: 120.0,
      rentPricePerDay: 8.0,
      availableQuantity: 3,
    ),
    SupplyItem(
      id: 's3',
      name: 'جهاز تبخيرة',
      description: 'Nebulizer للاستعمال المنزلي',
      buyPrice: 35.0,
      rentPricePerDay: 3.0,
      availableQuantity: 5,
    ),
  ];

  OrderStatus? _status;
  SupplyPurchaseType _purchaseType = SupplyPurchaseType.buy;
  int _rentDays = 1;
  SupplyItem? _selected;

  List<SupplyItem> get items => List.unmodifiable(_items);
  OrderStatus? get status => _status;
  SupplyPurchaseType get purchaseType => _purchaseType;
  int get rentDays => _rentDays;
  SupplyItem? get selected => _selected;

  void selectItem(SupplyItem item) {
    _selected = item;
    notifyListeners();
  }

  void setPurchaseType(SupplyPurchaseType type) {
    _purchaseType = type;
    notifyListeners();
  }

  void setRentDays(int value) {
    _rentDays = value.clamp(1, 60);
    notifyListeners();
  }

  double get totalCost {
    final item = _selected;
    if (item == null) return 0;
    if (_purchaseType == SupplyPurchaseType.buy) return item.buyPrice;
    return item.rentPricePerDay * _rentDays;
  }

  bool get canSubmit {
    final item = _selected;
    if (item == null) return false;
    return item.availableQuantity > 0;
  }

  Future<void> submitOrder() async {
    if (!canSubmit) return;
    _status = OrderStatus.pending;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));
    _status = OrderStatus.accepted;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));
    _status = OrderStatus.onTheWay;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));
    _status = OrderStatus.completed;
    notifyListeners();
  }
}

