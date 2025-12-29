import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String? username;
  final String? displayName;
  final String? photoURL;
  final String? location;
  final String? bio;
  final String? website;
  final String? pronoun;
  final String? dateOfBirth;
  final DateTime? createdAt;
  final bool showDisplayName;
  final String? provider;

  UserProfile({
    required this.uid,
    required this.email,
    this.username,
    this.displayName,
    this.photoURL,
    this.location,
    this.bio,
    this.website,
    this.pronoun,
    this.dateOfBirth,
    this.createdAt,
    this.showDisplayName = true,
    this.provider,
  });

  /// Create UserProfile from Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      username: data['username'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      location: data['location'],
      bio: data['bio'],
      website: data['website'],
      pronoun: data['pronoun'],
      dateOfBirth: data['dateOfBirth'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      showDisplayName: data['showDisplayName'] ?? true,
      provider: data['provider'],
    );
  }

  /// Convert UserProfile to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      if (username != null) 'username': username,
      if (displayName != null) 'displayName': displayName,
      if (photoURL != null) 'photoURL': photoURL,
      if (location != null) 'location': location,
      if (bio != null) 'bio': bio,
      if (website != null) 'website': website,
      if (pronoun != null) 'pronoun': pronoun,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      'showDisplayName': showDisplayName,
      if (provider != null) 'provider': provider,
    };
  }

  /// Get display name or username or email prefix
  String get effectiveDisplayName {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName!;
    }
    if (username != null && username!.isNotEmpty) {
      return username!;
    }
    return email.split('@').first;
  }

  /// Get formatted join date
  String get formattedJoinDate {
    if (createdAt == null) return '';
    final months = [
      '', 'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
      'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
    ];
    return 'Tham gia ${months[createdAt!.month]}, ${createdAt!.year}';
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? uid,
    String? email,
    String? username,
    String? displayName,
    String? photoURL,
    String? location,
    String? bio,
    String? website,
    String? pronoun,
    String? dateOfBirth,
    DateTime? createdAt,
    bool? showDisplayName,
    String? provider,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      pronoun: pronoun ?? this.pronoun,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      showDisplayName: showDisplayName ?? this.showDisplayName,
      provider: provider ?? this.provider,
    );
  }
}
