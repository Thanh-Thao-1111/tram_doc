import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user's UID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Get current user's email
  String? get currentUserEmail => _auth.currentUser?.email;

  /// Stream of current user's profile
  Stream<UserProfile?> get currentUserProfileStream {
    final uid = currentUserId;
    if (uid == null) return Stream.value(null);
    
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserProfile.fromFirestore(doc) : null);
  }

  /// Get current user's profile (one-time fetch)
  Future<UserProfile?> getCurrentUserProfile() async {
    final uid = currentUserId;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      // Create profile if it doesn't exist
      final user = _auth.currentUser!;
      await _firestore.collection('users').doc(uid).set({
        'email': user.email?.toLowerCase(),
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      final newDoc = await _firestore.collection('users').doc(uid).get();
      return UserProfile.fromFirestore(newDoc);
    }
    
    return UserProfile.fromFirestore(doc);
  }

  /// Update user profile
  Future<void> updateProfile(UserProfile profile) async {
    final uid = currentUserId;
    if (uid == null) throw 'Người dùng chưa đăng nhập';

    await _firestore.collection('users').doc(uid).update(profile.toFirestore());
  }

  /// Update a single profile field
  Future<void> updateProfileField(String field, dynamic value) async {
    final uid = currentUserId;
    if (uid == null) throw 'Người dùng chưa đăng nhập';

    await _firestore.collection('users').doc(uid).update({field: value});
  }

  /// Update multiple profile fields
  Future<void> updateProfileFields(Map<String, dynamic> fields) async {
    final uid = currentUserId;
    if (uid == null) throw 'Người dùng chưa đăng nhập';

    await _firestore.collection('users').doc(uid).update(fields);
  }

  /// Change user password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw 'Người dùng chưa đăng nhập';
    if (user.email == null) throw 'Không tìm thấy email người dùng';

    // Re-authenticate user before changing password
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      throw 'Mật khẩu hiện tại không đúng';
    }

    // Change password
    try {
      await user.updatePassword(newPassword);
    } catch (e) {
      throw 'Không thể đổi mật khẩu: $e';
    }
  }

  /// Delete user account
  Future<void> deleteAccount(String password) async {
    final user = _auth.currentUser;
    if (user == null) throw 'Người dùng chưa đăng nhập';
    if (user.email == null) throw 'Không tìm thấy email người dùng';

    // Re-authenticate before deletion
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      throw 'Mật khẩu không đúng';
    }

    // Delete user data from Firestore
    await _firestore.collection('users').doc(user.uid).delete();

    // Delete Firebase Auth account
    await user.delete();
  }
}
