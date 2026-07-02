import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../data/models/article.dart';
import '../../../../shared/widgets/article_list_tile.dart';
import '../../../../shared/widgets/category_chip.dart';
import '../../../../data/models/category.dart';
import '../../../article_detail/presentation/screens/article_detail_screen.dart';

/// Full-screen search overlay.
///
/// Features:
/// - Debounced (250ms) in-memory filter against [allArticles] title + excerpt
/// - Accent-tolerant matching (normalises common French accents)
/// - Live-updating [ArticleListTile] results
/// - Category quick-filter chips when the query is empty
/// - Clear "X" button resets query instantly
/// - Animated entrance; closes cleanly with Navigator.pop()
class SearchScreen extends StatefulWidget {
  final List<Article> allArticles;
  final List<Category> categories;

  const SearchScreen({
    super.key,
    required this.allArticles,
    required this.categories,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  String _query = '';
  String? _categoryFilter;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    // Auto-focus the text field after the animation completes
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    _focusNode.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {
          _query = value.trim();
          _categoryFilter = null; // clear category when typing
        });
      }
    });
  }

  void _clearQuery() {
    _textController.clear();
    setState(() {
      _query = '';
      _categoryFilter = null;
    });
    _focusNode.requestFocus();
  }

  void _selectCategory(String? id) {
    _textController.clear();
    setState(() {
      _query = '';
      _categoryFilter = id == _categoryFilter ? null : id;
    });
  }

  List<Article> get _results {
    if (_query.isEmpty && _categoryFilter == null) return [];

    return widget.allArticles.where((article) {
      // Category filter takes precedence when no text query
      if (_categoryFilter != null && _query.isEmpty) {
        return article.category.id == _categoryFilter;
      }
      // Text search — accent-insensitive, case-insensitive
      final q = _normalise(_query);
      final title = _normalise(article.title);
      final excerpt = _normalise(article.excerpt);
      final catMatch = _categoryFilter == null ||
          article.category.id == _categoryFilter;
      return catMatch && (title.contains(q) || excerpt.contains(q));
    }).toList();
  }

  /// Normalise string: lowercase + strip common French accents.
  String _normalise(String s) {
    return s
        .toLowerCase()
        .replaceAll(RegExp('[àâä]'), 'a')
        .replaceAll(RegExp('[éèêë]'), 'e')
        .replaceAll(RegExp('[îï]'), 'i')
        .replaceAll(RegExp('[ôö]'), 'o')
        .replaceAll(RegExp('[ùûü]'), 'u')
        .replaceAll('ç', 'c')
        .replaceAll('œ', 'oe')
        .replaceAll('æ', 'ae');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final results = _results;
    final isSearching = _query.isNotEmpty || _categoryFilter != null;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                color: isDark ? Colors.white : AppColors.primaryNavy,
                tooltip: 'Retour',
                onPressed: () => Navigator.of(context).pop(),
              ),
              // Search field
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  onChanged: _onQueryChanged,
                  style: AppTypography.uiBodyLarge.copyWith(
                    color: isDark ? Colors.white : AppColors.primaryNavy,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un article...',
                    hintStyle: AppTypography.uiBodyLarge.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    border: InputBorder.none,
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                            tooltip: 'Effacer',
                            onPressed: _clearQuery,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
        ),
        body: isSearching
            ? _buildResults(context, results, isDark)
            : _buildEmptyState(isDark),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.lg),
      children: [
        Text(
          'Rubriques',
          style: AppTypography.uiTitleMedium.copyWith(
            color: isDark ? Colors.white : AppColors.primaryNavy,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Wrap(
          spacing: AppSizes.sm,
          runSpacing: AppSizes.sm,
          children: widget.categories.map((cat) {
            return CategoryChip(
              category: cat,
              isSelected: cat.id == _categoryFilter,
              onTap: () => _selectCategory(cat.id),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSizes.xl),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.search_rounded,
                size: 48,
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.lightTextSecondary.withAlpha(100),
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                'Tapez pour rechercher\nou sélectionnez une rubrique',
                textAlign: TextAlign.center,
                style: AppTypography.uiBodyMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResults(
    BuildContext context,
    List<Article> results,
    bool isDark,
  ) {
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.lightTextSecondary.withAlpha(100),
              ),
              const SizedBox(height: AppSizes.md),
              Text(
                _query.isNotEmpty
                    ? 'Aucun résultat pour\n« $_query »'
                    : 'Aucun article dans cette rubrique',
                textAlign: TextAlign.center,
                style: AppTypography.uiBodyLarge.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        return ArticleListTile(
          key: ValueKey('search_${article.id}'),
          article: article,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ArticleDetailScreen(article: article),
            ),
          ),
        );
      },
    );
  }
}
