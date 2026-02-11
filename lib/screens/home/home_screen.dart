import 'package:flutter/material.dart';
import '../../features/ambulance/screens/ambulance_screen.dart';
import '../../features/consultations/screens/consultation_screen.dart';
import '../../features/diagnostics/screens/diagnostics_screen.dart';
import '../../features/medications/screens/medication_screen.dart';
import '../../features/nursing/screens/nursing_screen.dart';
import '../../features/supplies/screens/supplies_screen.dart';
import '../appointments_screen.dart';
import '../profile_screen.dart';
import '../search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeBody(),
      const SearchScreen(),
      const AppointmentsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomeBody() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: Colors.white,
          elevation: 0.5,
          surfaceTintColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF475569),
                  size: 20,
                ),
              ),
              Row(
                children: [
                  Text(
                    'CareHome',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F766E),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF14B8A6).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.health_and_safety,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildWelcomeCard(),
              const SizedBox(height: 28),
              _buildSectionHeader('خدماتنا المتخصصة'),
              const SizedBox(height: 16),
              _buildServicesGrid(),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
          stops: [0.1, 0.9],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'مرحباً بك',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 6),
                Text(
                  'كيف يمكننا مساعدتك اليوم؟',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.3,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    _buildFeatureChip('خدمة 24/7', Icons.access_time_filled),
                    _buildFeatureChip('استجابة سريعة', Icons.flash_on),
                    _buildFeatureChip('رعاية متكاملة', Icons.verified),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),
          Container(
            height: 80,
            child: const Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'عرض الكل',
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFF0D9488),
            fontWeight: FontWeight.w600,
          ),
          textDirection: TextDirection.rtl,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _buildServicesGrid() {
    final services = [
      _ServiceItem(
        icon: Icons.medication,
        title: 'طلب أدوية',
        subtitle: 'توصيل سريع للأدوية',
        color: const Color(0xFF0D9488),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _ServiceItem(
        icon: Icons.biotech,
        title: 'فحوصات منزلية',
        subtitle: 'نتائج دقيقة وسريعة',
        color: const Color(0xFF2563EB),
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _ServiceItem(
        icon: Icons.favorite,
        title: 'تمريض منزلي',
        subtitle: 'رعاية متخصصة وشاملة',
        color: const Color(0xFFDC2626),
        gradient: const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _ServiceItem(
        icon: Icons.local_hospital,
        title: 'نقل إسعافي',
        subtitle: 'استجابة طارئة فورية',
        color: const Color(0xFFD97706),
        gradient: const LinearGradient(
          colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _ServiceItem(
        icon: Icons.medical_information,
        title: 'استشارة طبية',
        subtitle: 'استشارات مجانية متخصصة',
        color: const Color(0xFF059669),
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _ServiceItem(
        icon: Icons.medical_services,
        title: 'مستلزمات طبية',
        subtitle: 'بيع وإيجار المعدات',
        color: const Color(0xFF7C3AED),
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final VoidCallback onTap = () {
          switch (service.title) {
            case 'طلب أدوية':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MedicationScreen()),
              );
              return;
            case 'فحوصات منزلية':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DiagnosticsScreen()),
              );
              return;
            case 'تمريض منزلي':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NursingScreen()),
              );
              return;
            case 'نقل إسعافي':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AmbulanceScreen()),
              );
              return;
            case 'استشارة طبية':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConsultationScreen()),
              );
              return;
            case 'مستلزمات طبية':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SuppliesScreen()),
              );
              return;
            default:
              return;
          }
        };
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
              splashColor: service.color.withOpacity(0.1),
              highlightColor: service.color.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: service.gradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: service.color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        service.icon,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          service.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service.subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: const Color(0xFF64748B),
                            height: 1.3,
                          ),
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home,
                label: 'الرئيسية',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.search,
                label: 'البحث',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.calendar_today,
                label: 'المواعيد',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person,
                label: 'حسابي',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF0D9488).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isActive
                  ? const Color(0xFF0D9488)
                  : const Color(0xFF94A3B8),
              size: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive
                  ? const Color(0xFF0D9488)
                  : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Gradient gradient;

  _ServiceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.gradient,
  });
}