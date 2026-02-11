import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/models/order_status.dart';
import '../models/diagnostic_test.dart';

class DiagnosticsViewModel extends ChangeNotifier {
  final List<DiagnosticTest> _tests = const [
    DiagnosticTest(
      id: 'd1',
      name: 'فحص دم شامل (CBC)',
      description: 'تعداد دم كامل',
      price: 12.0,
      category: 'دم',
    ),
    DiagnosticTest(
      id: 'd2',
      name: 'سكر تراكمي (HbA1c)',
      description: 'قياس متوسط السكر خلال 3 أشهر',
      price: 15.0,
      category: 'دم',
    ),
    DiagnosticTest(
      id: 'd3',
      name: 'سونار بطن',
      description: 'فحص بالموجات فوق الصوتية',
      price: 35.0,
      category: 'سونار',
    ),
    DiagnosticTest(
      id: 'd4',
      name: 'أشعة صدر (X-Ray)',
      description: 'تصوير أشعة للصدر',
      price: 25.0,
      category: 'أشعة',
    ),
  ];

  DiagnosticTest? _selected;
  DateTime? _date;
  TimeOfDay? _time;
  OrderStatus? _status;
  String? _resultNote;

  List<DiagnosticTest> get tests => List.unmodifiable(_tests);
  DiagnosticTest? get selected => _selected;
  DateTime? get date => _date;
  TimeOfDay? get time => _time;
  OrderStatus? get status => _status;
  String? get resultNote => _resultNote;

  void selectTest(DiagnosticTest test) {
    _selected = test;
    notifyListeners();
  }

  void setDate(DateTime value) {
    _date = value;
    notifyListeners();
  }

  void setTime(TimeOfDay value) {
    _time = value;
    notifyListeners();
  }

  void attachResultNote(String? value) {
    _resultNote = value;
    notifyListeners();
  }

  bool get canSubmit => _selected != null && _date != null && _time != null;

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

    await Future.delayed(const Duration(milliseconds: 1200));
    _status = OrderStatus.completed;
    notifyListeners();
  }
}

