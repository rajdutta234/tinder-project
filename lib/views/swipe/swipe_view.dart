import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/swipe_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_theme.dart';
import '../../widgets/user_card.dart';
import 'dart:math' as math;
import 'package:swipe_cards/swipe_cards.dart';

class SwipeView extends StatefulWidget {
  const SwipeView({super.key});

  @override
  State<SwipeView> createState() => _SwipeViewState();
}

class _SwipeViewState extends State<SwipeView> with SingleTickerProviderStateMixin {
  final SwipeController controller = Get.find<SwipeController>();
  IconData? _actionIcon;
  Color? _actionColor;
  AnimationController? _animController;
  Animation<double>? _scaleAnim;
  late MatchEngine _matchEngine;
  late List<SwipeItem> _swipeItems;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(parent: _animController!, curve: Curves.elasticOut);
    _swipeItems = controller.potentialMatches.map((user) {
      return SwipeItem(
        content: user,
        likeAction: () => controller.likeSpecificUser(user),
        nopeAction: () => controller.passSpecificUser(user),
        superlikeAction: () => controller.superLikeSpecificUser(user),
      );
    }).toList();
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  void dispose() {
    _animController?.dispose();
    super.dispose();
  }

  Future<void> _showActionAnimation(IconData icon, Color color) async {
    setState(() {
      _actionIcon = icon;
      _actionColor = color;
    });
    if (icon == Icons.star) {
      // Super Like: longer, bouncier, glowing, blue burst, shimmer
      _animController?.duration = const Duration(milliseconds: 1100);
      await _animController?.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 200));
      // Show a burst effect (overlay shimmer/particles)
      OverlayEntry? burstOverlay;
      burstOverlay = OverlayEntry(
        builder: (context) => Positioned.fill(
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 400),
              child: CustomPaint(
                painter: _SuperLikeBurstPainter(),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context)?.insert(burstOverlay);
      await Future.delayed(const Duration(milliseconds: 400));
      burstOverlay?.remove();
    } else {
      _animController?.duration = const Duration(milliseconds: 500);
      await _animController?.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 200));
    }
    setState(() {
      _actionIcon = null;
      _actionColor = null;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: const Text(
            'U2Me',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5, 
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.potentialMatches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  'No more profiles',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'Check back later for new matches',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing24),
                ElevatedButton(
                  onPressed: () => controller.loadPotentialMatches(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: SwipeCards(
                matchEngine: _matchEngine,
                itemBuilder: (BuildContext context, int index) {
                  final user = controller.potentialMatches[index];
                  return UserCard(user: user);
                },
                onStackFinished: () {
                  Get.snackbar('No more profiles', 'You have reached the end of the stack!');
                },
                likeTag: Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.favorite, color: Colors.green, size: 48),
                ),
                nopeTag: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.close, color: Colors.red, size: 48),
                ),
                superLikeTag: Align(
                  alignment: Alignment.bottomCenter,
                  child: Icon(Icons.star, color: Colors.blue, size: 48),
                ),
                upSwipeAllowed: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Tooltip(
                    message: 'Dislike',
                    child: InkResponse(
                      onTap: () => _matchEngine.currentItem?.nope(),
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 32, color: Colors.red),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Superlike',
                    child: InkResponse(
                      onTap: () => _matchEngine.currentItem?.superLike(),
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star, size: 32, color: Colors.blue),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Like',
                    child: InkResponse(
                      onTap: () => _matchEngine.currentItem?.like(),
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite, size: 32, color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    double size = 50,
    Color background = Colors.white,
    Color shadow = Colors.transparent,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: size * 0.5,
        ),
      ),
    );
  }
}

// Painter for superlike burst effect
class _SuperLikeBurstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.superLikeColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * math.pi;
      final radius = size.shortestSide * 0.25 + (i % 2 == 0 ? 10 : 0);
      final dx = center.dx + radius * math.cos(angle);
      final dy = center.dy + radius * math.sin(angle);
      canvas.drawCircle(Offset(dx, dy), 18, paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 