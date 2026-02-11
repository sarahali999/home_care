import 'package:flutter/foundation.dart';

import '../../../core/models/order_status.dart';
import '../models/nursing_service.dart';

class NursingViewModel extends ChangeNotifier {
  NursingServiceType _serviceType = NursingServiceType.injections;
  NursingDurationType _durationType = NursingDurationType.singleVisit;
  int _days = 1;
  String _notes = '';

  String? _assignedStaff;
  OrderStatus? _status;
  String? _visitReport;
  bool _patientSigned = false;

  NursingServiceType get serviceType => _serviceType;
  NursingDurationType get durationType => _durationType;
  int get days => _days;
  String get notes => _notes;
  String? get assignedStaff => _assignedStaff;
  OrderStatus? get status => _status;
  String? get visitReport => _visitReport;
  bool get patientSigned => _patientSigned;

  void setServiceType(NursingServiceType value) {
    _serviceType = value;
    notifyListeners();
  }

  void setDurationType(NursingDurationType value) {
    _durationType = value;
    notifyListeners();
  }

  void setDays(int value) {
    _days = value.clamp(1, 30);
    notifyListeners();
  }

  void setNotes(String value) {
    _notes = value;
    notifyListeners();
  }

  void setReport(String value) {
    _visitReport = value;
    notifyListeners();
  }

  void setSigned(bool value) {
    _patientSigned = value;
    notifyListeners();
  }

  List<String> get availableStaffByLocation => const [
        'ممرضة سارة (قريبة)',
        'ممرض محمد (متاح الآن)',
        'ممرضة ريم (متاح خلال ساعة)',
      ];

  void assignStaff(String staff) {
    _assignedStaff = staff;
    notifyListeners();
  }

  bool get canSubmit => _assignedStaff != null;

  Future<void> submitRequest() async {
    if (!canSubmit) return;
    _status = OrderStatus.pending;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));
    _status = OrderStatus.accepted;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));
    _status = OrderStatus.onTheWay;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));
    _status = OrderStatus.inProgress;
    notifyListeners();
  }

  Future<void> completeVisit() async {
    if (_status != OrderStatus.inProgress) return;
    if ((_visitReport ?? '').trim().isEmpty) return;
    if (!_patientSigned) return;

    await Future.delayed(const Duration(milliseconds: 700));
    _status = OrderStatus.completed;
    notifyListeners();
  }
}

