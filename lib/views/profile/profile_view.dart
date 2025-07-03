import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../controllers/auth_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.currentUser;
        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radius20),
                  boxShadow: AppTheme.shadowSmall,
                ),
                child: Column(
                  children: [
                    // Profile Image
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user.photos.isNotEmpty
                              ? CachedNetworkImageProvider(user.photos.first)
                              : null,
                          child: user.photos.isEmpty
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        if (user.isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.surface,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacing16),
                    
                    // Name and Age
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${user.name}, ${user.age}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (user.isVerified) ...[
                          const SizedBox(width: AppTheme.spacing8),
                          const Icon(
                            Icons.verified,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacing8),
                    
                    // Location
                    if (user.location.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.textSecondary,
                            size: 16,
                          ),
                          const SizedBox(width: AppTheme.spacing4),
                          Text(
                            user.location,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    
                    const SizedBox(height: AppTheme.spacing16),
                    
                    // Edit Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Get.toNamed(AppRoutes.editProfile),
                        child: const Text('Edit Profile'),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.spacing24),
              
              // About Section (Editable)
              _buildSection(
                title: 'About',
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _editAbout(context, user.bio),
                ),
                child: Text(user.bio, style: Theme.of(context).textTheme.bodyLarge),
              ),
              const SizedBox(height: AppTheme.spacing16),
              
              // Basic Info Section (Editable)
              _buildSection(
                title: 'Basic Info',
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _editBasicInfo(context, user),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Occupation', user.occupation),
                    _buildInfoRow('Education', user.education),
                    _buildInfoRow('Height', user.height > 0 ? '${user.height} cm' : ''),
                    _buildInfoRow('Looking for', user.lookingFor),
                    _buildInfoRow('Relationship goal', user.relationshipGoal),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.spacing16),
              
              // Interests Section (Editable)
              _buildSection(
                title: 'Interests',
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _editInterests(context, user.interests),
                ),
                child: Wrap(
                  spacing: AppTheme.spacing8,
                  runSpacing: AppTheme.spacing8,
                  children: user.interests.map((interest) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing12,
                        vertical: AppTheme.spacing8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radius20),
                      ),
                      child: Text(
                        interest,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              // Lifestyle Section (Editable)
              _buildSection(
                title: 'Lifestyle',
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _editLifestyle(context, user),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Smoking', user.smoking),
                    _buildInfoRow('Drinking', user.drinking),
                    _buildInfoRow('Religion', user.religion),
                    _buildInfoRow('Politics', user.politics),
                    _buildInfoRow('Zodiac sign', user.zodiacSign),
                  ],
                ),
              ),
              
              const SizedBox(height: AppTheme.spacing16),
              
              // Social Links Section (Editable)
              if (user.instagram.isNotEmpty || user.spotify.isNotEmpty) ...[
                _buildSection(
                  title: 'Social',
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _editSocial(context, user),
                  ),
                  child: Column(
                    children: [
                      if (user.instagram.isNotEmpty)
                        _buildSocialLink('Instagram', user.instagram, Icons.camera_alt),
                      if (user.spotify.isNotEmpty)
                        _buildSocialLink('Spotify', user.spotify, Icons.music_note),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),
              ],
              
              // Sign Out Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showSignOutDialog(context, controller),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.textInverse,
                  ),
                  child: const Text('Sign Out'),
                ),
              ),
              
              const SizedBox(height: AppTheme.spacing32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection({
    required String title,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLink(String platform, String handle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppTheme.spacing8),
          Text(
            '$platform: $handle',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AuthController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.signOut();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _editAbout(BuildContext context, String currentBio) {
    final controller = TextEditingController(text: currentBio);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit About'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'Tell us about yourself'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.find<AuthController>().updateBio(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editBasicInfo(BuildContext context, user) {
    final occupationController = TextEditingController(text: user.occupation);
    final educationController = TextEditingController(text: user.education);
    final heightController = TextEditingController(text: user.height > 0 ? user.height.toString() : '');
    final lookingForController = TextEditingController(text: user.lookingFor);
    final relationshipGoalController = TextEditingController(text: user.relationshipGoal);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Basic Info'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: occupationController, decoration: const InputDecoration(labelText: 'Occupation')),
              TextField(controller: educationController, decoration: const InputDecoration(labelText: 'Education')),
              TextField(controller: heightController, decoration: const InputDecoration(labelText: 'Height (cm)'), keyboardType: TextInputType.number),
              TextField(controller: lookingForController, decoration: const InputDecoration(labelText: 'Looking for')),
              TextField(controller: relationshipGoalController, decoration: const InputDecoration(labelText: 'Relationship goal')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.find<AuthController>().updateBasicInfo(
                occupation: occupationController.text,
                education: educationController.text,
                height: int.tryParse(heightController.text) ?? 0,
                lookingFor: lookingForController.text,
                relationshipGoal: relationshipGoalController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editInterests(BuildContext context, List<String> currentInterests) {
    final controller = TextEditingController();
    final interests = List<String>.from(currentInterests);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Interests'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                children: interests.map((interest) => Chip(
                  label: Text(interest),
                  onDeleted: () {
                    setState(() => interests.remove(interest));
                  },
                )).toList(),
              ),
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Add new interest'),
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    setState(() {
                      interests.add(val.trim());
                      controller.clear();
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Get.find<AuthController>().updateInterests(interests);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _editLifestyle(BuildContext context, user) {
    final smokingController = TextEditingController(text: user.smoking);
    final drinkingController = TextEditingController(text: user.drinking);
    final religionController = TextEditingController(text: user.religion);
    final politicsController = TextEditingController(text: user.politics);
    final zodiacController = TextEditingController(text: user.zodiacSign);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Lifestyle'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: smokingController, decoration: const InputDecoration(labelText: 'Smoking')),
              TextField(controller: drinkingController, decoration: const InputDecoration(labelText: 'Drinking')),
              TextField(controller: religionController, decoration: const InputDecoration(labelText: 'Religion')),
              TextField(controller: politicsController, decoration: const InputDecoration(labelText: 'Politics')),
              TextField(controller: zodiacController, decoration: const InputDecoration(labelText: 'Zodiac sign')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.find<AuthController>().updateLifestyle(
                smoking: smokingController.text,
                drinking: drinkingController.text,
                religion: religionController.text,
                politics: politicsController.text,
                zodiacSign: zodiacController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editSocial(BuildContext context, user) {
    final instagramController = TextEditingController(text: user.instagram);
    final spotifyController = TextEditingController(text: user.spotify);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Social Links'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: instagramController, decoration: const InputDecoration(labelText: 'Instagram')),
              TextField(controller: spotifyController, decoration: const InputDecoration(labelText: 'Spotify')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.find<AuthController>().updateSocial(
                instagram: instagramController.text,
                spotify: spotifyController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 