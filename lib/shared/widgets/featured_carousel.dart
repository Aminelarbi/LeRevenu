import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/article.dart';
import 'featured_article_card.dart';

/// An auto-advancing paged carousel for featured articles.
///
/// Behaviour contract:
/// - Pages advance automatically every [_autoAdvanceInterval].
/// - When the user drags the [PageView], the timer is cancelled so the
///   auto-advance never fights a live gesture.
/// - 2 seconds after the user lifts their finger, the timer restarts.
/// - The loop wraps gracefully: the last page advances to the first page.
/// - An animated dot-indicator tracks the active page.
/// - Timer is properly cancelled in [dispose] to prevent memory leaks.
class FeaturedCarousel extends StatefulWidget {
  final List<Article> articles;
  final ValueChanged<Article> onArticleTap;

  const FeaturedCarousel({
    super.key,
    required this.articles,
    required this.onArticleTap,
  });

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  static const Duration _autoAdvanceInterval = Duration(seconds: 5);
  static const Duration _resumeDelay = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    // viewportFraction < 1 makes adjacent cards peek at the edges.
    _pageController = PageController(viewportFraction: 0.92);
    _startTimer();
  }

  @override
  void dispose() {
    _cancelTimer();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _cancelTimer();
    if (widget.articles.length <= 1) return;
    _timer = Timer.periodic(_autoAdvanceInterval, (_) => _advancePage());
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _advancePage() {
    if (!_pageController.hasClients) return;
    final next = (_currentPage + 1) % widget.articles.length;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Paged carousel ──────────────────────────────────────────────
        SizedBox(
          height: 295,
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.articles.length,
            onPageChanged: _onPageChanged,
            // Detect user-initiated drag gestures to pause/restart auto-advance.
            // Using GestureDetector here would intercept taps on child cards,
            // so we hook into the ScrollNotification stream instead.
            itemBuilder: (context, index) {
              final article = widget.articles[index];
              return NotificationListener<ScrollStartNotification>(
                onNotification: (n) {
                  if (n.dragDetails != null) _cancelTimer();
                  return false;
                },
                child: NotificationListener<ScrollEndNotification>(
                  onNotification: (_) {
                    Future.delayed(_resumeDelay, () {
                      if (mounted) _startTimer();
                    });
                    return false;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xs,
                    ),
                    child: FeaturedArticleCard(
                      key: ValueKey('featured_${article.id}'),
                      article: article,
                      onTap: () => widget.onArticleTap(article),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Page indicator dots ──────────────────────────────────────────
        if (widget.articles.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.articles.length,
                (i) => _PageDot(isActive: i == _currentPage),
              ),
            ),
          ),
      ],
    );
  }
}

/// A single animated dot for the page indicator.
/// The active dot expands and fills with brand red; inactive dots are muted.
class _PageDot extends StatelessWidget {
  final bool isActive;

  const _PageDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: isActive
            ? AppColors.brandRed
            : (isDark
                  ? Colors.white.withAlpha(77)
                  : AppColors.primaryNavy.withAlpha(51)),
      ),
    );
  }
}
