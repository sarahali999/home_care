import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/order_status.dart';
import '../models/nursing_service.dart';
import '../viewmodels/nursing_view_model.dart';

class NursingScreen extends StatelessWidget {
  const NursingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NursingViewModel(),
      child: const _NursingView(),
    );
  }
}

class _NursingView extends StatelessWidget {
  const _NursingView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NursingViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('تمريض منزلي')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ServiceTypeCard(),
          const SizedBox(height: 12),
          _DurationCard(),
          const SizedBox(height: 12),
          _StaffCard(),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('ملاحظات', textDirection: TextDirection.rtl),
                  const SizedBox(height: 8),
                  TextField(
                    textDirection: TextDirection.rtl,
                    onChanged: vm.setNotes,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'مثال: حساسية من ... / تعليمات خاصة',
                    ),
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
          const SizedBox(height: 12),
          if (vm.status == null || vm.status == OrderStatus.pending) ...[],
          if (vm.status == OrderStatus.inProgress) _VisitReportCard(),
          if (vm.status == OrderStatus.completed)
            const Card(
              child: ListTile(
                leading: Icon(Icons.verified),
                title: Text('تمت الخدمة بنجاح', textDirection: TextDirection.rtl),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: vm.canSubmit && (vm.status == null)
                    ? () async {
                        await vm.submitRequest();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم إرسال الطلب')),
                          );
                        }
                      }
                    : null,
                child: const Text('طلب ممرض/ممرضة'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: vm.status == OrderStatus.inProgress
                    ? () async {
                        await vm.completeVisit();
                        if (context.mounted && vm.status == OrderStatus.completed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم إغلاق الزيارة')),
                          );
                        }
                      }
                    : null,
                child: const Text('إنهاء الزيارة'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceTypeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NursingViewModel>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'نوع الخدمة التمريضية',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<NursingServiceType>(
              value: vm.serviceType,
              items: const [
                DropdownMenuItem(
                  value: NursingServiceType.injections,
                  child: Text('حقن'),
                ),
                DropdownMenuItem(
                  value: NursingServiceType.ivFluids,
                  child: Text('محاليل'),
                ),
                DropdownMenuItem(
                  value: NursingServiceType.dressing,
                  child: Text('ضماد'),
                ),
                DropdownMenuItem(
                  value: NursingServiceType.elderlyCare,
                  child: Text('رعاية كبار السن'),
                ),
              ],
              onChanged: (v) {
                if (v != null) vm.setServiceType(v);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NursingViewModel>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'مدة الخدمة',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<NursingDurationType>(
              value: vm.durationType,
              items: const [
                DropdownMenuItem(
                  value: NursingDurationType.singleVisit,
                  child: Text('زيارة واحدة'),
                ),
                DropdownMenuItem(
                  value: NursingDurationType.hours24,
                  child: Text('24 ساعة'),
                ),
                DropdownMenuItem(
                  value: NursingDurationType.multipleDays,
                  child: Text('أيام متعددة'),
                ),
              ],
              onChanged: (v) {
                if (v != null) vm.setDurationType(v);
              },
            ),
            const SizedBox(height: 12),
            if (vm.durationType == NursingDurationType.multipleDays)
              Row(
                children: [
                  IconButton(
                    onPressed: () => vm.setDays(vm.days - 1),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('${vm.days} أيام'),
                  IconButton(
                    onPressed: () => vm.setDays(vm.days + 1),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  const Spacer(),
                  const Text('عدد الأيام', textDirection: TextDirection.rtl),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NursingViewModel>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'الطاقم المتوفر حسب الموقع',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            ...vm.availableStaffByLocation.map(
              (s) => RadioListTile<String>(
                value: s,
                groupValue: vm.assignedStaff,
                onChanged: (v) {
                  if (v != null) vm.assignStaff(v);
                },
                title: Text(s, textDirection: TextDirection.rtl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitReportCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NursingViewModel>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'تقرير الزيارة (Mock)',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'اكتب ملخص العلامات الحيوية والملاحظات (بدل رفع صور الآن).',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 10),
            TextField(
              textDirection: TextDirection.rtl,
              minLines: 3,
              maxLines: 6,
              onChanged: vm.setReport,
              decoration: const InputDecoration(
                hintText: 'مثال: ضغط 120/80، حرارة 36.8، ملاحظة...',
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              value: vm.patientSigned,
              onChanged: vm.setSigned,
              title: const Text('توقيع المريض (محاكاة)', textDirection: TextDirection.rtl),
            ),
          ],
        ),
      ),
    );
  }
}

