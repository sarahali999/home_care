import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/medication.dart';
import '../viewmodels/medication_view_model.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MedicationViewModel(),
      child: const _MedicationView(),
    );
  }
}

class _MedicationView extends StatelessWidget {
  const _MedicationView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MedicationViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلب الأدوية'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _AddressCard(
                  onChange: () {},
                ),
                const SizedBox(height: 12),
                if (vm.cartHasPrescriptionRequired) ...[
                  _PrescriptionCard(),
                  const SizedBox(height: 12),
                ],
                ...vm.medications.map((m) => _MedicationCard(medication: m)),
                const SizedBox(height: 12),
                if (vm.currentOrderStatus != null) _OrderStatusCard(),
              ],
            ),
          ),
          _CartSummary(),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final VoidCallback onChange;

  const _AddressCard({required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_on_outlined),
        title: const Text(
          'عنوان التوصيل',
          textDirection: TextDirection.rtl,
        ),
        subtitle: const Text(
          'موقعي الحالي (Mock GPS)',
          textDirection: TextDirection.rtl,
        ),
        trailing: TextButton(
          onPressed: onChange,
          child: const Text('تغيير'),
        ),
      ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MedicationViewModel>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'وصفة طبية مطلوبة',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'للتجربة: اكتب ملاحظة للوصفة (رفع صورة سيتم إضافته لاحقاً).',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 10),
            TextField(
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                hintText: 'مثال: وصفة بتاريخ ... من د. ...',
              ),
              onChanged: vm.setPrescriptionNote,
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final Medication medication;

  const _MedicationCard({required this.medication});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<MedicationViewModel>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          medication.name,
          textDirection: TextDirection.rtl,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 4),
            Text(
              medication.description,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (medication.requiresPrescription)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'يتطلب وصفة',
                      style: TextStyle(color: Colors.red, fontSize: 11),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  '${medication.price.toStringAsFixed(2)} د.ا',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => vm.addToCart(medication),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MedicationViewModel>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'الإجمالي: ${vm.cartTotal.toStringAsFixed(2)} د.ا',
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          ElevatedButton(
            onPressed: vm.cart.isEmpty
                ? null
                : () async {
                    await vm.placeOrder(
                      deliveryAddress: 'موقعي الحالي (Mock)',
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إرسال الطلب بنجاح')),
                      );
                    }
                  },
            child: const Text('إرسال الطلب'),
          ),
        ],
      ),
    );
  }
}

class _OrderStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final status = context.watch<MedicationViewModel>().currentOrderStatus;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.track_changes),
        title: const Text(
          'حالة الطلب',
          textDirection: TextDirection.rtl,
        ),
        subtitle: Text(
          status.toString(),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}

