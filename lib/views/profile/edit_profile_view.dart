import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../constants/app_colors.dart';
import '../../constants/app_theme.dart';
import '../../controllers/auth_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final AuthController controller = Get.find<AuthController>();
  bool _isUpdating = false;
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = controller.currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _locationController = TextEditingController(text: user?.location ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() => _isUpdating = true);
      try {
        final user = controller.currentUser;
        if (user != null) {
          final updatedPhotos = List<String>.from(user.photos);
          if (updatedPhotos.isNotEmpty) {
            updatedPhotos[0] = picked.path;
          } else {
            updatedPhotos.add(picked.path);
          }
          final updatedUser = user.copyWith(photos: updatedPhotos);
          await controller.updateProfile(updatedUser);
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to update profile picture');
      } finally {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = controller.currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isUpdating || user == null
                ? null
                : () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() => _isUpdating = true);
                      try {
                        final updatedUser = user.copyWith(
                          name: _nameController.text.trim(),
                          location: _locationController.text.trim(),
                        );
                        await controller.updateProfile(updatedUser);
                        Get.back();
                      } catch (e) {
                        Get.snackbar('Error', 'Failed to update profile');
                      } finally {
                        setState(() => _isUpdating = false);
                      }
                    }
                  },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        user.photos.isNotEmpty && !user.photos.first.startsWith('http')
                            ? CircleAvatar(
                                radius: 60,
                                backgroundImage: FileImage(File(user.photos.first)),
                              )
                            : user.photos.isNotEmpty && user.photos.first.startsWith('http')
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(user.photos.first),
                                  )
                                : const CircleAvatar(
                                    radius: 60,
                                    child: Icon(Icons.person, size: 60),
                                  ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _isUpdating ? null : _pickProfileImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: _isUpdating
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Icon(Icons.camera_alt, color: Colors.white, size: 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                    TextFormField(
                      controller: _nameController,
                      enabled: !_isUpdating,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => (value == null || value.trim().isEmpty) ? 'Name cannot be empty' : null,
                    ),
                    const SizedBox(height: AppTheme.spacing16),
                    TextFormField(
                      controller: _locationController,
                      enabled: !_isUpdating,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing24),
                  ],
                ),
              ),
            ),
    );
  }
} 