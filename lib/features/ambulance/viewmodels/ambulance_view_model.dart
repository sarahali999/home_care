import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/models/order_status.dart';

class AmbulanceViewModel extends ChangeNotifier {
  OrderStatus? _status;
  int _etaMinutes = 0;
  Timer? _timer;

  OrderStatus? get status => _status;
  int get etaMinutes => _etaMinutes;

  bool get isActive =>
      _status == OrderStatus.accepted ||
      _status == OrderStatus.onTheWay ||
      _status == OrderStatus.inProgress;

  Future<void> requestEmergency() async {
    _timer?.cancel();
    _status = OrderStatus.pending;
    _etaMinutes = 8;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));
    _status = OrderStatus.accepted;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));
    _status = OrderStatus.onTheWay;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_etaMinutes > 0) {
        _etaMinutes -= 1;
        notifyListeners();
      } else {
        t.cancel();
      }
    });

    await Future.delayed(const Duration(seconds: 8));
    _status = OrderStatus.inProgress;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 4));
    _status = OrderStatus.completed;
    _timer?.cancel();
    notifyListeners();
  }

  void cancel() {
    _timer?.cancel();
    _status = OrderStatus.cancelled;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

