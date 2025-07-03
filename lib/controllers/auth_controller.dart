import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isAuthenticated = false.obs;
  
  UserModel? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isAuthenticated => _isAuthenticated.value;
  
  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }
  
  Future<void> checkAuthStatus() async {
    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      
      if (userJson != null) {
        // In a real app, you would validate the token here
        _isAuthenticated.value = true;
        // _currentUser.value = UserModel.fromJson(jsonDecode(userJson));
      } else {
        _isAuthenticated.value = false;
      }
    } catch (e) {
      _isAuthenticated.value = false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock user data
      final user = UserModel(
        id: '1',
        name: 'John Doe',
        age: 25,
        bio: 'Love traveling and photography! 📸✈️',
        photos: [
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
        ],
        location: 'New York, NY',
        distance: 5.2,
        interests: ['Photography', 'Travel', 'Coffee', 'Music'],
        occupation: 'Software Engineer',
        education: 'Stanford University',
        height: 180,
        gender: 'Male',
        lookingFor: 'Female',
        isVerified: true,
        isOnline: true,
        lastActive: DateTime.now(),
        languages: ['English', 'Spanish'],
        relationshipGoal: 'Long-term relationship',
        hasChildren: false,
        smoking: 'Never',
        drinking: 'Socially',
        religion: 'Spiritual',
        politics: 'Moderate',
        zodiacSign: 'Libra',
        instagram: '@johndoe',
        spotify: 'spotify:user:johndoe',
      );
      
      _currentUser.value = user;
      _isAuthenticated.value = true;
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', user.toJson().toString());
      
      Get.offAllNamed('/main');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required int age,
    required String gender,
    required String lookingFor,
  }) async {
    _isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock user data
      final user = UserModel(
        id: '1',
        name: name,
        age: age,
        bio: '',
        photos: [],
        location: '',
        distance: 0,
        interests: [],
        occupation: '',
        education: '',
        height: 0,
        gender: gender,
        lookingFor: lookingFor,
        isVerified: false,
        isOnline: true,
        lastActive: DateTime.now(),
        languages: [],
        relationshipGoal: '',
        hasChildren: false,
        smoking: '',
        drinking: '',
        religion: '',
        politics: '',
        zodiacSign: '',
        instagram: '',
        spotify: '',
      );
      
      _currentUser.value = user;
      _isAuthenticated.value = true;
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', user.toJson().toString());
      
      Get.offAllNamed('/onboarding');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign up. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> signOut() async {
    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user');
      
      _currentUser.value = null;
      _isAuthenticated.value = false;
      
      Get.offAllNamed('/auth');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> updateProfile(UserModel updatedUser) async {
    _isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser.value = updatedUser;
      
      // Update local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', updatedUser.toJson().toString());
      
      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void updateBio(String newBio) {
    if (_currentUser.value != null) {
      _currentUser.value = _currentUser.value!.copyWith(bio: newBio);
      updateProfile(_currentUser.value!);
    }
  }

  void updateBasicInfo({String? occupation, String? education, int? height, String? lookingFor, String? relationshipGoal}) {
    if (_currentUser.value != null) {
      _currentUser.value = _currentUser.value!.copyWith(
        occupation: occupation ?? _currentUser.value!.occupation,
        education: education ?? _currentUser.value!.education,
        height: height ?? _currentUser.value!.height,
        lookingFor: lookingFor ?? _currentUser.value!.lookingFor,
        relationshipGoal: relationshipGoal ?? _currentUser.value!.relationshipGoal,
      );
      updateProfile(_currentUser.value!);
    }
  }

  void updateInterests(List<String> newInterests) {
    if (_currentUser.value != null) {
      _currentUser.value = _currentUser.value!.copyWith(interests: newInterests);
      updateProfile(_currentUser.value!);
    }
  }

  void updateLifestyle({String? smoking, String? drinking, String? religion, String? politics, String? zodiacSign}) {
    if (_currentUser.value != null) {
      _currentUser.value = _currentUser.value!.copyWith(
        smoking: smoking ?? _currentUser.value!.smoking,
        drinking: drinking ?? _currentUser.value!.drinking,
        religion: religion ?? _currentUser.value!.religion,
        politics: politics ?? _currentUser.value!.politics,
        zodiacSign: zodiacSign ?? _currentUser.value!.zodiacSign,
      );
      updateProfile(_currentUser.value!);
    }
  }

  void updateSocial({String? instagram, String? spotify}) {
    if (_currentUser.value != null) {
      _currentUser.value = _currentUser.value!.copyWith(
        instagram: instagram ?? _currentUser.value!.instagram,
        spotify: spotify ?? _currentUser.value!.spotify,
      );
      updateProfile(_currentUser.value!);
    }
  }

  Future<void> deleteAccount() async {
    _isLoading.value = true;
    try {
      // TODO: Implement real backend delete logic
      await Future.delayed(const Duration(seconds: 1));
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user');
      _currentUser.value = null;
      _isAuthenticated.value = false;
      Get.offAllNamed('/auth');
      Get.snackbar('Account Deleted', 'Your account has been deleted.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete account. Please try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      _isLoading.value = false;
    }
  }
} 