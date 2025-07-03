import 'package:get/get.dart';
import '../models/user_model.dart';

class SwipeController extends GetxController {
  static SwipeController get to => Get.find();
  
  final RxList<UserModel> _potentialMatches = <UserModel>[].obs;
  final RxList<UserModel> _likedUsers = <UserModel>[].obs;
  final RxList<UserModel> _passedUsers = <UserModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxInt _currentIndex = 0.obs;
  
  List<UserModel> get potentialMatches => _potentialMatches;
  List<UserModel> get likedUsers => _likedUsers;
  List<UserModel> get passedUsers => _passedUsers;
  bool get isLoading => _isLoading.value;
  int get currentIndex => _currentIndex.value;
  bool get hasMoreCards => _currentIndex.value < _potentialMatches.length;
  
  UserModel? get currentCard {
    if (_currentIndex.value < _potentialMatches.length) {
      return _potentialMatches[_currentIndex.value];
    }
    return null;
  }
  
  @override
  void onInit() {
    super.onInit();
    loadPotentialMatches();
  }
  
  Future<void> loadPotentialMatches() async {
    _isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      final mockUsers = [
        UserModel(
          id: '2',
          name: 'Sarah Johnson',
          age: 24,
          bio: 'Adventure seeker and coffee enthusiast ☕️🏔️',
          photos: [
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400',
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
          ],
          location: 'San Francisco, CA',
          distance: 3.1,
          interests: ['Hiking', 'Coffee', 'Photography', 'Yoga'],
          occupation: 'Marketing Manager',
          education: 'UC Berkeley',
          height: 165,
          gender: 'Female',
          lookingFor: 'Male',
          isVerified: true,
          isOnline: true,
          lastActive: DateTime.now(),
          languages: ['English', 'French'],
          relationshipGoal: 'Long-term relationship',
          hasChildren: false,
          smoking: 'Never',
          drinking: 'Socially',
          religion: 'Agnostic',
          politics: 'Liberal',
          zodiacSign: 'Gemini',
          instagram: '@sarahjohnson',
          spotify: 'spotify:user:sarahjohnson',
        ),
        UserModel(
          id: '3',
          name: 'Emma Wilson',
          age: 26,
          bio: 'Artist and nature lover 🎨🌿',
          photos: [
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
            'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=400',
          ],
          location: 'Los Angeles, CA',
          distance: 8.5,
          interests: ['Art', 'Nature', 'Cooking', 'Reading'],
          occupation: 'Graphic Designer',
          education: 'Art Center College',
          height: 170,
          gender: 'Female',
          lookingFor: 'Male',
          isVerified: true,
          isOnline: false,
          lastActive: DateTime.now().subtract(const Duration(hours: 2)),
          languages: ['English', 'Spanish'],
          relationshipGoal: 'Casual dating',
          hasChildren: false,
          smoking: 'Socially',
          drinking: 'Socially',
          religion: 'Spiritual',
          politics: 'Moderate',
          zodiacSign: 'Cancer',
          instagram: '@emmawilson',
          spotify: 'spotify:user:emmawilson',
        ),
        UserModel(
          id: '4',
          name: 'Michael Chen',
          age: 28,
          bio: 'Tech entrepreneur and fitness enthusiast 💪💻',
          photos: [
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
          ],
          location: 'Seattle, WA',
          distance: 12.3,
          interests: ['Technology', 'Fitness', 'Travel', 'Music'],
          occupation: 'Startup Founder',
          education: 'MIT',
          height: 175,
          gender: 'Male',
          lookingFor: 'Female',
          isVerified: true,
          isOnline: true,
          lastActive: DateTime.now(),
          languages: ['English', 'Mandarin'],
          relationshipGoal: 'Long-term relationship',
          hasChildren: false,
          smoking: 'Never',
          drinking: 'Rarely',
          religion: 'Atheist',
          politics: 'Liberal',
          zodiacSign: 'Aries',
          instagram: '@michaelchen',
          spotify: 'spotify:user:michaelchen',
        ),
        UserModel(
          id: '5',
          name: 'Jessica Brown',
          age: 23,
          bio: 'Foodie and travel blogger 🍕✈️',
          photos: [
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400',
          ],
          location: 'Miami, FL',
          distance: 15.7,
          interests: ['Food', 'Travel', 'Photography', 'Dancing'],
          occupation: 'Content Creator',
          education: 'University of Miami',
          height: 168,
          gender: 'Female',
          lookingFor: 'Male',
          isVerified: true,
          isOnline: true,
          lastActive: DateTime.now(),
          languages: ['English', 'Spanish', 'Italian'],
          relationshipGoal: 'Casual dating',
          hasChildren: false,
          smoking: 'Never',
          drinking: 'Socially',
          religion: 'Catholic',
          politics: 'Conservative',
          zodiacSign: 'Leo',
          instagram: '@jessicabrown',
          spotify: 'spotify:user:jessicabrown',
        ),
      ];
      
      _potentialMatches.assignAll(mockUsers);
      _currentIndex.value = 0;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load potential matches.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
  
  void likeUser() {
    if (currentCard != null) {
      _likedUsers.add(currentCard!);
      _moveToNextCard();
      
      // Simulate match check
      _checkForMatch(currentCard!);
    }
  }
  
  void passUser() {
    if (currentCard != null) {
      _passedUsers.add(currentCard!);
      _moveToNextCard();
    }
  }
  
  void superLikeUser() {
    if (currentCard != null) {
      _likedUsers.add(currentCard!);
      _moveToNextCard();
      
      // Simulate super like match
      _checkForSuperLikeMatch(currentCard!);
    }
  }
  
  void _moveToNextCard() {
    if (_currentIndex.value < _potentialMatches.length - 1) {
      _currentIndex.value++;
    } else {
      // No more cards, reload
      loadPotentialMatches();
    }
  }
  
  void _checkForMatch(UserModel likedUser) {
    // Simulate 30% match probability
    if (DateTime.now().millisecondsSinceEpoch % 3 == 0) {
      Get.snackbar(
        'It\'s a Match! 💕',
        'You and ${likedUser.name} liked each other!',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  void _checkForSuperLikeMatch(UserModel superLikedUser) {
    // Simulate 80% match probability for super like
    if (DateTime.now().millisecondsSinceEpoch % 5 != 0) {
      Get.snackbar(
        'Super Like Match! ⭐',
        '${superLikedUser.name} super liked you back!',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  void resetSwipe() {
    _currentIndex.value = 0;
    _likedUsers.clear();
    _passedUsers.clear();
  }
  
  void undoLastSwipe() {
    if (_likedUsers.isNotEmpty) {
      final lastLiked = _likedUsers.removeLast();
      _potentialMatches.insert(_currentIndex.value, lastLiked);
    } else if (_passedUsers.isNotEmpty) {
      final lastPassed = _passedUsers.removeLast();
      _potentialMatches.insert(_currentIndex.value, lastPassed);
    }
  }
  
  void likeSpecificUser(UserModel user) {
    _likedUsers.add(user);
    _potentialMatches.remove(user);
    // Optionally: _checkForMatch(user);
    update();
  }
  
  void passSpecificUser(UserModel user) {
    _passedUsers.add(user);
    _potentialMatches.remove(user);
    update();
  }
  
  void superLikeSpecificUser(UserModel user) {
    _likedUsers.add(user);
    _potentialMatches.remove(user);
    // Optionally: _checkForSuperLikeMatch(user);
    update();
  }
} 