import 'package:flutter/foundation.dart';

import '../../../core/models/order_status.dart';
import '../models/cart_item.dart';
import '../models/medication.dart';

class MedicationViewModel extends ChangeNotifier {
  final List<Medication> _allMedications = const [
    Medication(
      id: 'm1',
      name: 'باراسيتامول 500 ملغ',
      description: 'مسكن للألم وخافض للحرارة',
      requiresPrescription: false,
      price: 3.50,
    ),
    Medication(
      id: 'm2',
      name: 'أموكسيسيلين 500 ملغ',
      description: 'مضاد حيوي واسع الطيف',
      requiresPrescription: true,
      price: 7.00,
    ),
    Medication(
      id: 'm3',
      name: 'أوميبرازول 20 ملغ',
      description: 'لعلاج الحموضة وارتجاع المريء',
      requiresPrescription: false,
      price: 5.25,
    ),
  ];

  final List<MedicationCartItem> _cart = [];
  OrderStatus? _currentOrderStatus;
  String? _prescriptionNote;

  List<Medication> get medications => List.unmodifiable(_allMedications);
  List<MedicationCartItem> get cart => List.unmodifiable(_cart);
  OrderStatus? get currentOrderStatus => _currentOrderStatus;
  String? get prescriptionNote => _prescriptionNote;

  double get cartTotal => _cart.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get cartHasPrescriptionRequired =>
      _cart.any((item) => item.medication.requiresPrescription);

  void setPrescriptionNote(String? value) {
    _prescriptionNote = value;
    notifyListeners();
  }

  void addToCart(Medication medication) {
    final index = _cart.indexWhere((c) => c.medication.id == medication.id);
    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(MedicationCartItem(medication: medication));
    }
    notifyListeners();
  }

  void updateQuantity(Medication medication, int quantity) {
    final index = _cart.indexWhere((c) => c.medication.id == medication.id);
    if (index < 0) return;

    if (quantity <= 0) {
      _cart.removeAt(index);
    } else {
      _cart[index].quantity = quantity;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _currentOrderStatus = null;
    _prescriptionNote = null;
    notifyListeners();
  }

  Future<void> placeOrder({
    required String deliveryAddress,
    String? notes,
  }) async {
    if (_cart.isEmpty) return;

    _currentOrderStatus = OrderStatus.pending;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));
    _currentOrderStatus = OrderStatus.accepted;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));
    _currentOrderStatus = OrderStatus.preparing;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));
    _currentOrderStatus = OrderStatus.onTheWay;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));
    _currentOrderStatus = OrderStatus.completed;
    notifyListeners();

    _cart.clear();
  }
}

