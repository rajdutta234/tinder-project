import 'package:get/get.dart';
import '../models/match_model.dart';
import '../models/user_model.dart';
import '../controllers/auth_controller.dart';
import '../models/message_model.dart';

class MatchesController extends GetxController {
  static MatchesController get to => Get.find();
  
  final RxList<MatchModel> _matches = <MatchModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _selectedMatchId = ''.obs;
  
  // Mock messages storage: matchId -> List<MessageModel>
  final RxMap<String, List<MessageModel>> _messages = <String, List<MessageModel>>{}.obs;
  
  List<MatchModel> get matches {
    final userId = Get.find<AuthController>().currentUser?.id;
    if (userId == null) return [];
    return _matches.where((match) => match.user1.id == userId || match.user2.id == userId).toList();
  }
  bool get isLoading => _isLoading.value;
  String get selectedMatchId => _selectedMatchId.value;
  
  MatchModel? get selectedMatch {
    try {
      return _matches.firstWhere((match) => match.id == _selectedMatchId.value);
    } catch (e) {
      return null;
    }
  }
  
  List<MessageModel> get currentMessages {
    final id = _selectedMatchId.value;
    return _messages[id] ?? [];
  }
  
  @override
  void onInit() {
    super.onInit();
    loadMatches();
  }
  
  Future<void> loadMatches() async {
    _isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock matches data
      final mockMatches = [
        MatchModel(
          id: '1',
          user1: UserModel(
            id: '1',
            name: 'John Doe',
            age: 25,
            bio: 'Love traveling and photography! 📸✈️',
            photos: ['https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'],
            location: 'New York, NY',
            distance: 0,
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
          ),
          user2: UserModel(
            id: '2',
            name: 'Sarah Johnson',
            age: 24,
            bio: 'Adventure seeker and coffee enthusiast ☕️🏔️',
            photos: ['https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400'],
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
          matchedAt: DateTime.now().subtract(const Duration(days: 2)),
          isActive: true,
          lastMessageAt: DateTime.now().subtract(const Duration(hours: 1)),
          unreadCount: 2,
          lastMessage: 'Hey! How was your weekend? 😊',
        ),
        MatchModel(
          id: '2',
          user1: UserModel(
            id: '1',
            name: 'John Doe',
            age: 25,
            bio: 'Love traveling and photography! 📸✈️',
            photos: ['https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'],
            location: 'New York, NY',
            distance: 0,
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
          ),
          user2: UserModel(
            id: '3',
            name: 'Emma Wilson',
            age: 26,
            bio: 'Artist and nature lover 🎨🌿',
            photos: ['https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400'],
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
          matchedAt: DateTime.now().subtract(const Duration(days: 5)),
          isActive: true,
          lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
          unreadCount: 0,
          lastMessage: 'Thanks for the coffee recommendation! ☕️',
        ),
        MatchModel(
          id: '3',
          user1: UserModel(
            id: '1',
            name: 'John Doe',
            age: 25,
            bio: 'Love traveling and photography! 📸✈️',
            photos: ['https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'],
            location: 'New York, NY',
            distance: 0,
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
          ),
          user2: UserModel(
            id: '4',
            name: 'Jessica Brown',
            age: 23,
            bio: 'Foodie and travel blogger 🍕✈️',
            photos: ['https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400'],
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
          matchedAt: DateTime.now().subtract(const Duration(hours: 6)),
          isActive: true,
          lastMessageAt: DateTime.now().subtract(const Duration(minutes: 30)),
          unreadCount: 1,
          lastMessage: 'That sounds amazing! I\'d love to join you next time 🍕',
        ),
      ];
      
      _matches.assignAll(mockMatches);
      
      // Add mock messages for each match
      for (final match in mockMatches) {
        _messages[match.id] = [
          MessageModel(
            id: 'm1',
            senderId: match.user1.id,
            receiverId: match.user2.id,
            content: match.lastMessage ?? 'Hello!',
            type: MessageType.text,
            timestamp: match.lastMessageAt ?? match.matchedAt,
            isRead: true,
          ),
        ];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load matches.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
  
  void selectMatch(String matchId) {
    _selectedMatchId.value = matchId;
  }
  
  void clearSelectedMatch() {
    _selectedMatchId.value = '';
  }
  
  Future<void> sendMessage(String matchId, String content) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Update the match with new message
      final matchIndex = _matches.indexWhere((match) => match.id == matchId);
      if (matchIndex != -1) {
        final updatedMatch = _matches[matchIndex].copyWith(
          lastMessageAt: DateTime.now(),
          lastMessage: content,
          unreadCount: 0,
        );
        _matches[matchIndex] = updatedMatch;
        
        // Add message to messages map
        final match = _matches[matchIndex];
        final senderId = match.user1.id; // Assume current user is user1 for mock
        final receiverId = match.user2.id;
        final msg = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: senderId,
          receiverId: receiverId,
          content: content,
          type: MessageType.text,
          timestamp: DateTime.now(),
          isRead: true,
        );
        _messages[matchId] = List<MessageModel>.from(_messages[matchId] ?? [])..add(msg);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void markAsRead(String matchId) {
    final matchIndex = _matches.indexWhere((match) => match.id == matchId);
    if (matchIndex != -1) {
      final updatedMatch = _matches[matchIndex].copyWith(unreadCount: 0);
      _matches[matchIndex] = updatedMatch;
    }
  }
  
  void unmatch(String matchId) {
    _matches.removeWhere((match) => match.id == matchId);
    if (_selectedMatchId.value == matchId) {
      _selectedMatchId.value = '';
    }
  }
  
  List<MatchModel> get sortedMatches {
    final sorted = List<MatchModel>.from(_matches);
    sorted.sort((a, b) => (b.lastMessageAt ?? b.matchedAt).compareTo(a.lastMessageAt ?? a.matchedAt));
    return sorted;
  }
} 