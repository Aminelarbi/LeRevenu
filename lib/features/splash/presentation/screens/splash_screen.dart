import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/repositories/home_repository.dart';
import '../../../../data/repositories/mock_home_repository.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../widgets/splash_motif.dart';

/// Flutter-rendered branded splash screen with a three-beat reveal.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _revealController;
  late final AnimationController _exitController;
  late final Animation<double> _motifOpacity;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _indicatorOpacity;
  double _progress = 0.32;

  @override
  void initState() {
    super.initState();

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1350),
    )..forward();

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );

    _motifOpacity = CurvedAnimation(
      parent: _revealController,
      curve: const Interval(0.0, 0.28, curve: Curves.easeOut),
    );
    _logoOpacity = CurvedAnimation(
      parent: _revealController,
      curve: const Interval(0.18, 0.56, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: const Interval(0.18, 0.56, curve: Curves.easeOutBack),
      ),
    );
    _taglineOpacity = CurvedAnimation(
      parent: _revealController,
      curve: const Interval(0.42, 0.74, curve: Curves.easeOut),
    );
    _indicatorOpacity = CurvedAnimation(
      parent: _revealController,
      curve: const Interval(0.64, 0.92, curve: Curves.easeOut),
    );

    final HomeRepository repo = MockHomeRepository();
    final dataFuture = Future.wait([
      repo.getArticles(),
      repo.getCategories(),
      repo.getMarketIndices(),
    ]);
    final minDurationFuture = Future.delayed(
      const Duration(milliseconds: 1500),
    );

    Future.wait([dataFuture, minDurationFuture]).then((_) {
      if (!mounted) return;
      setState(() => _progress = 0.72);
      Future.delayed(const Duration(milliseconds: 160), () {
        if (!mounted) return;
        setState(() => _progress = 1.0);
        _exitController.forward().whenComplete(() {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 360),
              pageBuilder: (_, __, ___) => const HomeScreen(),
              transitionsBuilder: (_, animation, __, child) => FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ),
                child: child,
              ),
            ),
          );
        });
      });
    });
  }

  @override
  void dispose() {
    _revealController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_revealController, _exitController]),
      builder: (context, _) {
        final exitProgress = _exitController.value;
        final motifOpacity = (_motifOpacity.value * (1 - exitProgress * 1.35)).clamp(0.0, 1.0);
        final contentOpacity = (1 - exitProgress * 0.95).clamp(0.0, 1.0);

        return Scaffold(
          backgroundColor: AppColors.primaryNavy,
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: motifOpacity,
                  child: const SplashMotif(opacity: 1.0),
                ),
                Column(
                  children: [
                    const Spacer(flex: 2),
                    FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Opacity(
                          opacity: contentOpacity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 82,
                                height: 82,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(60),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  'assets/le_revenu_logo.jpeg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Text(
                                      'LR',
                                      style: TextStyle(
                                        color: Color(0xFF1A365D),
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'LE REVENU',
                                style: AppTypography.editorialHeadlineLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 32,
                                  letterSpacing: 4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FadeTransition(
                                opacity: _taglineOpacity,
                                child: Text(
                                  'L\'information financière, simplifiée',
                                  style: AppTypography.uiBodyMedium.copyWith(
                                    color: Colors.white.withAlpha(170),
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                    FadeTransition(
                      opacity: _indicatorOpacity,
                      child: Opacity(
                        opacity: contentOpacity,
                        child: _LoadingSignal(progress: _progress),
                      ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoadingSignal extends StatelessWidget {
  final double progress;

  const _LoadingSignal({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: List.generate(3, (index) {
              final segmentProgress = ((progress * 3) - index).clamp(0.0, 1.0);
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 2 ? 0 : 6),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: segmentProgress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.brandRed.withAlpha(220),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            progress < 0.7 ? 'Chargement en cours' : 'Presque prêt',
            style: AppTypography.uiLabelMedium.copyWith(
              color: Colors.white.withAlpha(160),
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
