import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/diagnostic_test.dart';
import '../viewmodels/diagnostics_view_model.dart';

class DiagnosticsScreen extends StatelessWidget {
  const DiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiagnosticsViewModel(),
      child: const _DiagnosticsView(),
    );
  }
}

class _DiagnosticsView extends StatelessWidget {
  const _DiagnosticsView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DiagnosticsViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('فحوصات منزلية')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _ScheduleCard(),
          const SizedBox(height: 12),
          const Text(
            'اختر الفحص',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ...vm.tests.map((t) => _TestCard(test: t)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'رفع النتيجة (Mock)',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'في المرحلة الحالية: اكتب ملاحظة لنتيجة الفحص بدل رفع ملف PDF/IMG.',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    textDirection: TextDirection.rtl,
                    onChanged: vm.attachResultNote,
                    decoration: const InputDecoration(
                      hintText: 'مثال: النتيجة طبيعية... إلخ',
                    ),
                    minLines: 2,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (vm.status != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.track_changes),
                title: const Text('حالة الطلب', textDirection: TextDirection.rtl),
                subtitle: Text(vm.status.toString(),
                    textDirection: TextDirection.rtl),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: vm.canSubmit
              ? () async {
                  await vm.submitRequest();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حجز الموعد بنجاح')),
                    );
                  }
                }
              : null,
          child: const Text('تأكيد الحجز'),
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DiagnosticsViewModel>();

    final dateText = vm.date == null
        ? 'اختر التاريخ'
        : '${vm.date!.year}-${vm.date!.month.toString().padLeft(2, '0')}-${vm.date!.day.toString().padLeft(2, '0')}';
    final timeText = vm.time == null
        ? 'اختر الوقت'
        : vm.time!.format(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'الموعد',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: now,
                        lastDate: now.add(const Duration(days: 60)),
                        initialDate: vm.date ?? now,
                      );
                      if (picked != null) vm.setDate(picked);
                    },
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(dateText),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: vm.time ?? TimeOfDay.now(),
                      );
                      if (picked != null) vm.setTime(picked);
                    },
                    icon: const Icon(Icons.access_time),
                    label: Text(timeText),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الموقع: موقعي الحالي (Mock GPS)',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  final DiagnosticTest test;
  const _TestCard({required this.test});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DiagnosticsViewModel>();
    final selected = vm.selected?.id == test.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        selected: selected,
        leading: const Icon(Icons.biotech),
        title: Text(test.name, textDirection: TextDirection.rtl),
        subtitle: Text(
          '${test.description}\nالفئة: ${test.category} • السعر: ${test.price.toStringAsFixed(2)} د.ا',
          textDirection: TextDirection.rtl,
        ),
        trailing: const Icon(Icons.chevron_left),
        onTap: () => vm.selectTest(test),
      ),
    );
  }
}

