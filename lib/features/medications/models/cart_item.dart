import 'medication.dart';

class MedicationCartItem {
  final Medication medication;
  int quantity;

  MedicationCartItem({
    required this.medication,
    this.quantity = 1,
  });

  double get totalPrice => medication.price * quantity;
}

