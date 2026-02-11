class Medication {
  final String id;
  final String name;
  final String description;
  final bool requiresPrescription;
  final double price;

  const Medication({
    required this.id,
    required this.name,
    required this.description,
    required this.requiresPrescription,
    required this.price,
  });
}

