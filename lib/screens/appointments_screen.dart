import 'package:flutter/material.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('المواعيد'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _AppointmentCard(
            title: 'فحص دم شامل (محاكاة)',
            subtitle: 'الخميس 10:30 ص • بانتظار التأكيد',
            icon: Icons.biotech,
          ),
          _AppointmentCard(
            title: 'زيارة تمريض (محاكاة)',
            subtitle: 'السبت 6:00 م • في الطريق',
            icon: Icons.favorite,
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const _AppointmentCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, textDirection: TextDirection.rtl),
        subtitle: Text(subtitle, textDirection: TextDirection.rtl),
        trailing: const Icon(Icons.chevron_left),
      ),
    );
  }
}

