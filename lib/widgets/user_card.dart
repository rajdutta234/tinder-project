import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_theme.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radius20),
        boxShadow: AppTheme.shadowLarge,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radius20),
        child: Stack(
          children: [
            // Main Image
            if (user.photos.isNotEmpty)
              CachedNetworkImage(
                imageUrl: user.photos.first,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Container(
                  color: AppColors.surface,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surface,
                  child: const Icon(
                    Icons.person,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                ),
              )
            else
              Container(
                color: AppColors.surface,
                child: const Icon(
                  Icons.person,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
              ),
            
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            
            // User Info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacing20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Age
                    Row(
                      children: [
                        Text(
                          '${user.name}, ${user.age}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textInverse,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (user.isVerified) ...[
                          const SizedBox(width: AppTheme.spacing8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: AppColors.textInverse,
                              size: 16,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacing8),
                    
                    // Location
                    if (user.location.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.textInverse,
                            size: 16,
                          ),
                          const SizedBox(width: AppTheme.spacing4),
                          Text(
                            user.location,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textInverse.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    
                    const SizedBox(height: AppTheme.spacing12),
                    
                    // Bio
                    if (user.bio.isNotEmpty)
                      Text(
                        user.bio,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textInverse.withOpacity(0.9),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    
                    const SizedBox(height: AppTheme.spacing12),
                    
                    // Interests
                    if (user.interests.isNotEmpty)
                      Wrap(
                        spacing: AppTheme.spacing8,
                        runSpacing: AppTheme.spacing4,
                        children: user.interests.take(3).map((interest) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing12,
                              vertical: AppTheme.spacing8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.textInverse.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppTheme.radius20),
                            ),
                            child: Text(
                              interest,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textInverse,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            
            // Photo Counter
            if (user.photos.length > 1)
              Positioned(
                top: AppTheme.spacing16,
                right: AppTheme.spacing16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing12,
                    vertical: AppTheme.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(AppTheme.radius20),
                  ),
                  child: Text(
                    '1/${user.photos.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textInverse,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 