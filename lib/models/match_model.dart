import 'user_model.dart';

class MatchModel {
  final String id;
  final UserModel user1;
  final UserModel user2;
  final DateTime matchedAt;
  final bool isActive;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final String? lastMessage;

  MatchModel({
    required this.id,
    required this.user1,
    required this.user2,
    required this.matchedAt,
    required this.isActive,
    this.lastMessageAt,
    required this.unreadCount,
    this.lastMessage,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] ?? '',
      user1: UserModel.fromJson(json['user1'] ?? {}),
      user2: UserModel.fromJson(json['user2'] ?? {}),
      matchedAt: DateTime.parse(json['matchedAt'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
      lastMessageAt: json['lastMessageAt'] != null 
          ? DateTime.parse(json['lastMessageAt']) 
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      lastMessage: json['lastMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1': user1.toJson(),
      'user2': user2.toJson(),
      'matchedAt': matchedAt.toIso8601String(),
      'isActive': isActive,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'unreadCount': unreadCount,
      'lastMessage': lastMessage,
    };
  }

  MatchModel copyWith({
    String? id,
    UserModel? user1,
    UserModel? user2,
    DateTime? matchedAt,
    bool? isActive,
    DateTime? lastMessageAt,
    int? unreadCount,
    String? lastMessage,
  }) {
    return MatchModel(
      id: id ?? this.id,
      user1: user1 ?? this.user1,
      user2: user2 ?? this.user2,
      matchedAt: matchedAt ?? this.matchedAt,
      isActive: isActive ?? this.isActive,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
} 