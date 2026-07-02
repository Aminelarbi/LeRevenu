import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/market_index.dart';

/// A continuously auto-scrolling marquee-style ticker bar showing market data.
///
/// Root cause of previous non-animation: the previous implementation called
/// [AnimationController.repeat()] while also manually writing to
/// [AnimationController.value] inside a listener — the repeat() mechanism
/// overrides any manual value assignments each frame, so the scroll offset
/// was being reset to 0 continuously and never actually advanced.
///
/// This version uses [SingleTickerProviderStateMixin.createTicker] directly
/// (via [Ticker]), paired with a [ScrollController] driven via jumpTo().
/// This is the canonical pattern for programmatic constant-speed scrolling.
///
/// Seamless loop: the list is duplicated so the wrap-back to offset 0
/// is invisible (no snap gap).
class MarketTickerBar extends StatefulWidget {
  final List<MarketIndex> indices;

  const MarketTickerBar({super.key, required this.indices});

  @override
  State<MarketTickerBar> createState() => _MarketTickerBarState();
}

class _MarketTickerBarState extends State<MarketTickerBar>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final Ticker _ticker;
  double _offset = 0;

  /// Logical pixels per second — tune for desired speed.
  static const double _speed = 35.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    // ~60 fps increment: speed / 60 px per frame
    _offset += _speed / 60.0;
    // Wrap at the halfway point (first copy ends, second copy begins)
    if (_offset >= maxScroll / 2) _offset = 0;
    _scrollController.jumpTo(_offset);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Duplicate the list for a seamless loop (no visible gap when wrapping)
    final doubledList = [...widget.indices, ...widget.indices];

    return Container(
      height: AppSizes.marketTickerHeight,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.primaryNavy,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.white.withAlpha(25),
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        // NeverScrollableScrollPhysics: driven programmatically only,
        // user dragging is intentionally disabled on this ticker strip.
        physics: const NeverScrollableScrollPhysics(),
        itemCount: doubledList.length,
        itemBuilder: (context, index) {
          return _TickerItem(index: doubledList[index]);
        },
      ),
    );
  }
}

/// Renders a single market index item inside the scrolling ticker.
class _TickerItem extends StatelessWidget {
  final MarketIndex index;

  const _TickerItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final color = index.isUp ? AppColors.gainGreen : AppColors.lossRed;
    final icon = index.isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down;

    final String formattedValue = index.value < 10
        ? index.value.toStringAsFixed(4)
        : index.value.toStringAsFixed(2);

    final String sign = index.variationPercent >= 0 ? '+' : '';
    final String formattedPercent =
        '$sign${index.variationPercent.toStringAsFixed(2)}%';

    return Container(
      margin: const EdgeInsets.only(right: AppSizes.xl),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            index.name,
            style: AppTypography.marketTickerText.copyWith(
              color: Colors.white,
            ),
          ),
          AppSizes.spacingSm,
          Text(
            formattedValue,
            style: AppTypography.marketTickerSubtext.copyWith(
              color: Colors.white.withAlpha(204),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          AppSizes.spacingXs,
          Icon(icon, color: color, size: 16),
          Text(
            formattedPercent,
            style: AppTypography.marketTickerSubtext.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Container(height: 14, width: 1, color: Colors.white.withAlpha(51)),
        ],
      ),
    );
  }
}
