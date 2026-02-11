import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/supply_item.dart';
import '../viewmodels/supplies_view_model.dart';

class SuppliesScreen extends StatelessWidget {
  const SuppliesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SuppliesViewModel(),
      child: const _SuppliesView(),
    );
  }
}

class _SuppliesView extends StatelessWidget {
  const _SuppliesView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SuppliesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مستلزمات طبية'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _PurchaseTypeSelector(),
          const SizedBox(height: 12),
          if (vm.purchaseType == SupplyPurchaseType.rent) ...[
            const _RentDaysSelector(),
            const SizedBox(height: 12),
          ],
          const Text(
            'اختر منتجاً',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ...vm.items.map((item) => _SupplyCard(item: item)),
          const SizedBox(height: 12),
          _SummaryCard(),
          const SizedBox(height: 12),
          if (vm.status != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.track_changes),
                title: const Text(
                  'حالة الطلب',
                  textDirection: TextDirection.rtl,
                ),
                subtitle: Text(
                  vm.status.toString(),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: vm.canSubmit
              ? () async {
                  await vm.submitOrder();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إرسال الطلب بنجاح')),
                    );
                  }
                }
              : null,
          child: const Text('تأكيد الطلب'),
        ),
      ),
    );
  }
}

class _PurchaseTypeSelector extends StatelessWidget {
  const _PurchaseTypeSelector();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SuppliesViewModel>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: SegmentedButton<SupplyPurchaseType>(
                segments: const [
                  ButtonSegment(
                    value: SupplyPurchaseType.buy,
                    label: Text('شراء'),
                    icon: Icon(Icons.shopping_bag_outlined),
                  ),
                  ButtonSegment(
                    value: SupplyPurchaseType.rent,
                    label: Text('استئجار'),
                    icon: Icon(Icons.timelapse),
                  ),
                ],
                selected: {vm.purchaseType},
                onSelectionChanged: (set) {
                  vm.setPurchaseType(set.first);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RentDaysSelector extends StatelessWidget {
  const _RentDaysSelector();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SuppliesViewModel>();
    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_today_outlined),
        title: const Text(
          'مدة الاستئجار (بالأيام)',
          textDirection: TextDirection.rtl,
        ),
        trailing: SizedBox(
          width: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => vm.setRentDays(vm.rentDays - 1),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('${vm.rentDays}'),
              IconButton(
                onPressed: () => vm.setRentDays(vm.rentDays + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupplyCard extends StatelessWidget {
  final SupplyItem item;
  const _SupplyCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SuppliesViewModel>();
    final selected = vm.selected?.id == item.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        selected: selected,
        leading: const Icon(Icons.medical_services_outlined),
        title: Text(item.name, textDirection: TextDirection.rtl),
        subtitle: Text(
          '${item.description}\nمتوفر: ${item.availableQuantity}',
          textDirection: TextDirection.rtl,
        ),
        trailing: const Icon(Icons.chevron_left),
        onTap: () => vm.selectItem(item),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SuppliesViewModel>();
    final selected = vm.selected;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'الملخص',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              selected == null ? 'لم يتم اختيار منتج بعد' : selected.name,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 6),
            Text(
              'التكلفة: ${vm.totalCost.toStringAsFixed(2)} د.ا',
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

