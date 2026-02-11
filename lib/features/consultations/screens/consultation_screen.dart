import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_message.dart';
import '../viewmodels/consultation_view_model.dart';

class ConsultationScreen extends StatelessWidget {
  const ConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConsultationViewModel(),
      child: const _ConsultationView(),
    );
  }
}

class _ConsultationView extends StatefulWidget {
  const _ConsultationView();

  @override
  State<_ConsultationView> createState() => _ConsultationViewState();
}

class _ConsultationViewState extends State<_ConsultationView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsultationViewModel>();
    _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: const Text('استشارة مجانية'),
      ),
      body: Column(
        children: [
          _CategoryBar(
            value: vm.category,
            onChanged: vm.setCategory,
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: vm.messages.length,
              itemBuilder: (context, index) {
                final msg = vm.messages[index];
                return _Bubble(message: msg);
              },
            ),
          ),
          _Composer(
            controller: _controller,
            onSend: () async {
              final text = _controller.text;
              _controller.clear();
              await context.read<ConsultationViewModel>().sendMessage(text);
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final ConsultationCategory value;
  final ValueChanged<ConsultationCategory> onChanged;

  const _CategoryBar({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: SegmentedButton<ConsultationCategory>(
              segments: const [
                ButtonSegment(
                  value: ConsultationCategory.medication,
                  label: Text('دوائية'),
                  icon: Icon(Icons.medication_outlined),
                ),
                ButtonSegment(
                  value: ConsultationCategory.mildSymptoms,
                  label: Text('أعراض بسيطة'),
                  icon: Icon(Icons.sick_outlined),
                ),
                ButtonSegment(
                  value: ConsultationCategory.general,
                  label: Text('عام'),
                  icon: Icon(Icons.chat_bubble_outline),
                ),
              ],
              selected: {value},
              onSelectionChanged: (set) => onChanged(set.first),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage message;
  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatSender.user;
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isUser ? const Color(0xFF0D9488) : Colors.white;
    final textColor = isUser ? Colors.white : const Color(0xFF0F172A);

    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: isUser ? null : Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Text(
          message.text,
          textDirection: TextDirection.rtl,
          style: TextStyle(color: textColor, height: 1.4),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _Composer({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton(
              onPressed: onSend,
              icon: const Icon(Icons.send),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  hintText: 'اكتب رسالتك...',
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

