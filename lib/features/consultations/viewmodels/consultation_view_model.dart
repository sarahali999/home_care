import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';

enum ConsultationCategory { medication, mildSymptoms, general }

class ConsultationViewModel extends ChangeNotifier {
  ConsultationCategory _category = ConsultationCategory.general;
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      sender: ChatSender.doctor,
      text: 'مرحباً! كيف يمكنني مساعدتك اليوم؟',
      timestamp: DateTime.now(),
    ),
  ];

  ConsultationCategory get category => _category;
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void setCategory(ConsultationCategory value) {
    _category = value;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: ChatSender.user,
        text: trimmed,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();

    // محاكاة رد طبيب + إشعار
    await Future.delayed(const Duration(milliseconds: 900));
    _messages.add(
      ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        sender: ChatSender.doctor,
        text: _autoReply(trimmed, _category),
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  String _autoReply(String userText, ConsultationCategory cat) {
    switch (cat) {
      case ConsultationCategory.medication:
        return 'للاستخدام الآمن: اذكر اسم الدواء/الجرعة/العمر/الحساسية. إذا كان لديك وصفة، اتبع تعليمات الطبيب.';
      case ConsultationCategory.mildSymptoms:
        return 'من فضلك اذكر مدة الأعراض ودرجة الحرارة وأي أمراض مزمنة. إذا ظهرت علامات خطورة (ضيق نفس/ألم صدر) اطلب إسعافاً فوراً.';
      case ConsultationCategory.general:
        return 'تم استلام سؤالك. هل يمكنك توضيح العمر والأعراض/الاستفسار بالتفصيل؟';
    }
  }
}

