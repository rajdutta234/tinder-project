import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_theme.dart';
import '../../routes/app_routes.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _occupationController = TextEditingController();
  final _educationController = TextEditingController();
  final _locationController = TextEditingController();
  
  List<String> _selectedInterests = [];
  String _selectedRelationshipGoal = 'Long-term relationship';
  String _selectedSmoking = 'Never';
  String _selectedDrinking = 'Socially';
  String _selectedReligion = 'Spiritual';
  String _selectedPolitics = 'Moderate';
  String _selectedZodiacSign = 'Libra';
  
  final List<String> _interests = [
    'Photography', 'Travel', 'Coffee', 'Music', 'Hiking', 'Art', 'Nature',
    'Cooking', 'Reading', 'Fitness', 'Technology', 'Dancing', 'Yoga',
    'Gaming', 'Movies', 'Fashion', 'Sports', 'Food', 'Pets', 'Writing'
  ];
  
  final List<String> _relationshipGoals = [
    'Long-term relationship',
    'Casual dating',
    'Friendship',
    'Marriage',
    'Not sure yet'
  ];
  
  final List<String> _smokingOptions = ['Never', 'Socially', 'Regularly', 'Trying to quit'];
  final List<String> _drinkingOptions = ['Never', 'Socially', 'Regularly', 'Rarely'];
  final List<String> _religionOptions = ['Atheist', 'Agnostic', 'Spiritual', 'Religious', 'Other'];
  final List<String> _politicsOptions = ['Liberal', 'Conservative', 'Moderate', 'Apolitical'];
  final List<String> _zodiacSigns = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
  ];

  @override
  void dispose() {
    _bioController.dispose();
    _occupationController.dispose();
    _educationController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us about yourself',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                'This helps us find better matches for you',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: AppTheme.spacing32),
              
              // Bio
              TextFormField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  hintText: 'Tell us about yourself...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please add a bio';
                  }
                  if (value.length < 10) {
                    return 'Bio must be at least 10 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppTheme.spacing20),
              
              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'City, State',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your location';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppTheme.spacing20),
              
              // Occupation
              TextFormField(
                controller: _occupationController,
                decoration: const InputDecoration(
                  labelText: 'Occupation',
                  hintText: 'What do you do?',
                  prefixIcon: Icon(Icons.work),
                ),
              ),
              
              const SizedBox(height: AppTheme.spacing20),
              
              // Education
              TextFormField(
                controller: _educationController,
                decoration: const InputDecoration(
                  labelText: 'Education',
                  hintText: 'Where did you study?',
                  prefixIcon: Icon(Icons.school),
                ),
              ),
              
              const SizedBox(height: AppTheme.spacing24),
              
              // Interests
              Text(
                'Interests',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacing12),
              Wrap(
                spacing: AppTheme.spacing8,
                runSpacing: AppTheme.spacing8,
                children: _interests.map((interest) {
                  final isSelected = _selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          if (_selectedInterests.length < 5) {
                            _selectedInterests.add(interest);
                          } else {
                            Get.snackbar(
                              'Maximum Interests',
                              'You can select up to 5 interests',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        } else {
                          _selectedInterests.remove(interest);
                        }
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  );
                }).toList(),
              ),
              
              const SizedBox(height: AppTheme.spacing24),
              
              // Relationship Goal
              _buildDropdown(
                label: 'Relationship Goal',
                value: _selectedRelationshipGoal,
                items: _relationshipGoals,
                onChanged: (value) {
                  setState(() {
                    _selectedRelationshipGoal = value!;
                  });
                },
              ),
              
              const SizedBox(height: AppTheme.spacing20),
              
              // Lifestyle Section
              Text(
                'Lifestyle',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
              
              _buildDropdown(
                label: 'Smoking',
                value: _selectedSmoking,
                items: _smokingOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedSmoking = value!;
                  });
                },
              ),
              
              const SizedBox(height: AppTheme.spacing16),
              
              _buildDropdown(
                label: 'Drinking',
                value: _selectedDrinking,
                items: _drinkingOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedDrinking = value!;
                  });
                },
              ),
              
              const SizedBox(height: AppTheme.spacing16),
              
              _buildDropdown(
                label: 'Religion',
                value: _selectedReligion,
                items: _religionOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedReligion = value!;
                  });
                },
              ),
              
              const SizedBox(height: AppTheme.spacing16),
              
              _buildDropdown(
                label: 'Politics',
                value: _selectedPolitics,
                items: _politicsOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedPolitics = value!;
                  });
                },
              ),
              
              const SizedBox(height: AppTheme.spacing16),
              
              _buildDropdown(
                label: 'Zodiac Sign',
                value: _selectedZodiacSign,
                items: _zodiacSigns,
                onChanged: (value) {
                  setState(() {
                    _selectedZodiacSign = value!;
                  });
                },
              ),
              
              const SizedBox(height: AppTheme.spacing32),
              
              // Complete Profile Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleCompleteProfile,
                  child: const Text('Complete Profile'),
                ),
              ),
              
              const SizedBox(height: AppTheme.spacing16),
              
              // Skip Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.main),
                  child: const Text('Skip for now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _handleCompleteProfile() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = _authController.currentUser;
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          bio: _bioController.text.trim(),
          location: _locationController.text.trim(),
          occupation: _occupationController.text.trim(),
          education: _educationController.text.trim(),
          interests: _selectedInterests,
          relationshipGoal: _selectedRelationshipGoal,
          smoking: _selectedSmoking,
          drinking: _selectedDrinking,
          religion: _selectedReligion,
          politics: _selectedPolitics,
          zodiacSign: _selectedZodiacSign,
        );
        
        await _authController.updateProfile(updatedUser);
        Get.offAllNamed(AppRoutes.main);
      }
    }
  }
} 