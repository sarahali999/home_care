enum NursingServiceType {
  injections,
  ivFluids,
  dressing,
  elderlyCare,
}

enum NursingDurationType {
  singleVisit,
  hours24,
  multipleDays,
}

class NursingServiceRequest {
  final NursingServiceType serviceType;
  final NursingDurationType durationType;
  final int days;
  final String notes;

  const NursingServiceRequest({
    required this.serviceType,
    required this.durationType,
    required this.days,
    required this.notes,
  });
}

