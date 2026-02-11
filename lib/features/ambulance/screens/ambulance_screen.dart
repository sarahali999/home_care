import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/ambulance_view_model.dart';

class AmbulanceScreen extends StatelessWidget {
  const AmbulanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AmbulanceViewModel(),
      child: const _AmbulanceView(),
    );
  }
}

class _AmbulanceView extends StatelessWidget {
  const _AmbulanceView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AmbulanceViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('طلب إسعاف')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'طوارئ',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'اضغط الزر لإرسال إحداثياتك فوراً (Mock GPS) وإرسال أقرب سيارة إسعاف.',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.warning_amber_rounded),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                      ),
                      onPressed: vm.isActive
                          ? null
                          : () async {
                              await vm.requestEmergency();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تمت معالجة حالة الطوارئ'),
                                  ),
                                );
                              }
                            },
                      label: const Text('زر الطوارئ'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('موقعي', textDirection: TextDirection.rtl),
              subtitle:
                  const Text('إحداثيات: (Mock) 31.95, 35.91', textDirection: TextDirection.rtl),
              trailing: TextButton(onPressed: () {}, child: const Text('تحديث')),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: const Text('الوقت المتوقع للوصول (ETA)', textDirection: TextDirection.rtl),
              subtitle: Text(
                vm.status == null ? '—' : '${vm.etaMinutes} دقيقة (محاكاة)',
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (vm.status != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.track_changes),
                title: const Text('حالة الطلب', textDirection: TextDirection.rtl),
                subtitle: Text(vm.status.toString(), textDirection: TextDirection.rtl),
                trailing: vm.isActive
                    ? TextButton(
                        onPressed: vm.cancel,
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(color: Color(0xFFDC2626)),
                        ),
                      )
                    : null,
              ),
            ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    'أرقام الطوارئ',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Text('الإسعاف: 199', textDirection: TextDirection.rtl),
                  Text('الدعم: 16000', textDirection: TextDirection.rtl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

