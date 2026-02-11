import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('حسابي'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: const Text('مستخدم', textDirection: TextDirection.rtl),
              subtitle: const Text('07XX XXX XXXX', textDirection: TextDirection.rtl),
              trailing: TextButton(onPressed: () {}, child: const Text('تعديل')),
            ),
          ),
          const SizedBox(height: 12),
          _SettingTile(
            icon: Icons.history,
            title: 'سجل الطلبات',
            onTap: () {},
          ),
          _SettingTile(
            icon: Icons.medical_information_outlined,
            title: 'السجل الصحي',
            onTap: () {},
          ),
          _SettingTile(
            icon: Icons.support_agent_outlined,
            title: 'الدعم والتذاكر',
            onTap: () {},
          ),
          _SettingTile(
            icon: Icons.star_rate_outlined,
            title: 'تقييم الخدمات',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFDC2626)),
              title: const Text('تسجيل الخروج', textDirection: TextDirection.rtl),
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, textDirection: TextDirection.rtl),
        trailing: const Icon(Icons.chevron_left),
        onTap: onTap,
      ),
    );
  }
}

