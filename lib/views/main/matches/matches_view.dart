import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../controllers/matches_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_theme.dart';
import '../../../routes/app_routes.dart';
import '../../../controllers/auth_controller.dart';

class MatchesView extends StatelessWidget {
  const MatchesView({super.key});

  @override
  Widget build(BuildContext context) {
    final MatchesController controller = Get.find<MatchesController>();
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Matches'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (controller.matches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  'No matches yet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'Start swiping to find your matches!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          itemCount: controller.sortedMatches.length,
          itemBuilder: (context, index) {
            final match = controller.sortedMatches[index];
            final currentUserId = Get.find<AuthController>().currentUser?.id;
            final otherUser = match.user1.id == currentUserId ? match.user2 : match.user1;
            
            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.radius16),
                boxShadow: AppTheme.shadowSmall,
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(AppTheme.spacing16),
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: otherUser.photos.isNotEmpty
                          ? CachedNetworkImageProvider(otherUser.photos.first)
                          : null,
                      child: otherUser.photos.isEmpty
                          ? const Icon(Icons.person, size: 30)
                          : null,
                    ),
                    if (otherUser.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surface,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Row(
                  children: [
                    Text(
                      otherUser.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing8),
                    Text(
                      '${otherUser.age}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (otherUser.isVerified) ...[
                      const SizedBox(width: AppTheme.spacing8),
                      const Icon(
                        Icons.verified,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ],
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.spacing4),
                    if (match.lastMessage != null) ...[
                      Text(
                        match.lastMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                    ],
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: AppTheme.spacing4),
                        Text(
                          _getTimeAgo(match.lastMessageAt ?? match.matchedAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        if (match.unreadCount > 0) ...[
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing8,
                              vertical: AppTheme.spacing4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppTheme.radius12),
                            ),
                            child: Text(
                              match.unreadCount.toString(),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textInverse,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  controller.selectMatch(match.id);
                  Get.toNamed(AppRoutes.chat);
                },
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'unmatch') {
                      _showUnmatchDialog(context, controller, match.id);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'unmatch',
                      child: Row(
                        children: [
                          Icon(Icons.block, color: AppColors.error),
                          SizedBox(width: AppTheme.spacing8),
                          Text('Unmatch'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showUnmatchDialog(BuildContext context, MatchesController controller, String matchId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unmatch'),
        content: const Text('Are you sure you want to unmatch? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.unmatch(matchId);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Unmatch'),
          ),
        ],
      ),
    );
  }
} 