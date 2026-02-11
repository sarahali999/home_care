import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  bool _isLastPage = false;

  final List<OnboardingData> _pages = [
    const OnboardingData(
      icon: Icons.medical_services_rounded,
      title: 'خدمات طبية شاملة',
      description: 'احصل على كل ما تحتاجه من أدوية، فحوصات منزلية، وتمريض متخصص في مكان واحد',
    ),
    const OnboardingData(
      icon: Icons.home_rounded,
      title: 'رعاية في منزلك',
      description: 'فريق طبي محترف يصل إليك أينما كنت، مع متابعة لحظية وخدمة على مدار الساعة',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupSystemUI();
    _pageController.addListener(_updatePageState);
  }

  void _setupSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFF5F7FA),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _updatePageState() {
    if (_pageController.hasClients) {
      final page = _pageController.page?.round() ?? 0;
      if (_currentPage.value != page) {
        _currentPage.value = page;
        _isLastPage = page == _pages.length - 1;
      }
    }
  }

  void _handleNextAction() {
    if (_isLastPage) {
      _navigateToAuth();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _navigateToAuth() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.removeListener(_updatePageState);
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Stack(
          children: [
            // Skip Button في الأعلى
            Positioned(
              top: 16,
              right: 16,
              child: ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (context, page, child) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: page < _pages.length - 1 ? 1.0 : 0.0,
                    child: TextButton(
                      onPressed: _navigateToAuth,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6B7280),
                      ),
                      child: const Text(
                        'تخطي',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),

            // المحتوى الرئيسي
            Column(
              children: [
                const SizedBox(height: 80), // مساحة للزر تخطي

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (page) {
                      _currentPage.value = page;
                      _isLastPage = page == _pages.length - 1;
                    },
                    itemBuilder: (context, index) {
                      return _OnboardingContent(
                        data: _pages[index],
                        onAction: _handleNextAction,
                        isLast: index == _pages.length - 1,
                      );
                    },
                  ),
                ),

                _buildPageIndicator(),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: ValueListenableBuilder<int>(
        valueListenable: _currentPage,
        builder: (context, page, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
                  (index) => _PageIndicator(
                isActive: page == index,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  final OnboardingData data;
  final VoidCallback onAction;
  final bool isLast;

  const _OnboardingContent({
    required this.data,
    required this.onAction,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 200,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _AnimatedIconIllustration(icon: data.icon),
            const SizedBox(height: 48),
            _AnimatedTitleText(text: data.title),
            const SizedBox(height: 16),
            _AnimatedDescriptionText(text: data.description),
            const SizedBox(height: 48),
            _AnimatedActionButton(
              text: isLast ? 'ابدأ الآن' : 'التالي',
              onPressed: onAction,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _AnimatedIconIllustration extends StatefulWidget {
  final IconData icon;

  const _AnimatedIconIllustration({required this.icon});

  @override
  State<_AnimatedIconIllustration> createState() => _AnimatedIconIllustrationState();
}

class _AnimatedIconIllustrationState extends State<_AnimatedIconIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: Curves.elasticOut.transform(_controller.value),
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0F2F1),
                  Color(0xFFB2DFDB),
                ],
              ),
              borderRadius: BorderRadius.circular(90),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00A8A8).withOpacity(0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF00D4D4),
                      Color(0xFF00A8A8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF00A8A8),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  size: 46,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedTitleText extends StatefulWidget {
  final String text;

  const _AnimatedTitleText({required this.text});

  @override
  State<_AnimatedTitleText> createState() => _AnimatedTitleTextState();
}

class _AnimatedTitleTextState extends State<_AnimatedTitleText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _translateAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _translateAnimation.value),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.3,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedDescriptionText extends StatefulWidget {
  final String text;

  const _AnimatedDescriptionText({required this.text});

  @override
  State<_AnimatedDescriptionText> createState() => _AnimatedDescriptionTextState();
}

class _AnimatedDescriptionTextState extends State<_AnimatedDescriptionText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _translateAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _translateAnimation.value),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.8,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const _AnimatedActionButton({
    required this.text,
    required this.onPressed,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onPressed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF00A8A8),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                  shadowColor: const Color(0xFF00A8A8).withOpacity(0.3),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Colors.white,
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
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: isActive ? 28 : 8,
      height: 8,
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
          colors: [
            Color(0xFF00D4D4),
            Color(0xFF00A8A8),
          ],
        )
            : null,
        color: !isActive ? const Color(0xFFB2DFDB) : null,
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
          BoxShadow(
            color: const Color(0xFF00A8A8).withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : null,
      ),
    );
  }
}

@immutable
class OnboardingData {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
  });
}