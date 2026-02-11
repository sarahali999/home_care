import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'الكل';

  final List<String> _filters = ['الكل', 'أدوية', 'فحوصات', 'أطباء', 'خدمات'];

  final List<_SearchResult> _allResults = [
    _SearchResult(
      title: 'باراسيتامول 500 ملغ',
      subtitle: 'دواء مسكن للألم',
      category: 'أدوية',
      icon: Icons.medication,
      color: const Color(0xFF0D9488),
    ),
    _SearchResult(
      title: 'فحص دم شامل',
      subtitle: 'تحليل CBC',
      category: 'فحوصات',
      icon: Icons.biotech,
      color: const Color(0xFF2563EB),
    ),
    _SearchResult(
      title: 'د. أحمد محمد',
      subtitle: 'طبيب عام',
      category: 'أطباء',
      icon: Icons.person,
      color: const Color(0xFF059669),
    ),
    _SearchResult(
      title: 'تمريض منزلي',
      subtitle: 'رعاية متخصصة',
      category: 'خدمات',
      icon: Icons.favorite,
      color: const Color(0xFFDC2626),
    ),
  ];

  List<_SearchResult> get _filteredResults {
    if (_selectedFilter == 'الكل') {
      return _allResults;
    }
    return _allResults.where((r) => r.category == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('البحث'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // شريط البحث
          _buildSearchBar(),

          // الفلاتر
          _buildFilters(),

          // النتائج
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        textDirection: TextDirection.rtl,
        decoration: const InputDecoration(
          hintText: 'ابحث عن أدوية، فحوصات، أطباء...',
          hintTextDirection: TextDirection.rtl,
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Color(0xFF64748B)),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;

          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedFilter = filter);
              },
              selectedColor: const Color(0xFF0D9488),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResults() {
    final results = _filteredResults;

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد نتائج',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return _buildResultCard(results[index]);
      },
    );
  }

  Widget _buildResultCard(_SearchResult result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.arrow_back_ios_rounded,
            size: 16,
            color: Color(0xFF0D9488),
          ),

          const Spacer(),

          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  result.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 4),
                Text(
                  result.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: result.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    result.category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: result.color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  result.color,
                  result.color.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: result.color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              result.icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _SearchResult {
  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final Color color;

  _SearchResult({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.color,
  });
}