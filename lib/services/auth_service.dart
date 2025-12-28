import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email or username
  Future<UserCredential> signIn({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      String email = emailOrUsername.trim();
      
      // Check if input is email (contains @)
      if (!email.contains('@')) {
        // Input is username, lookup email from Firestore
        final emailFromDb = await getEmailByUsername(email);
        if (emailFromDb == null) {
          throw 'Không tìm thấy tài khoản với tên người dùng này';
        }
        email = emailFromDb;
      }

      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Get email by username from Firestore
  Future<String?> getEmailByUsername(String username) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return querySnapshot.docs.first.data()['email'] as String?;
  }

  /// Save user info to Firestore after registration
  Future<void> saveUserToFirestore({
    required String uid,
    required String email,
    required String username,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email.trim().toLowerCase(),
      'username': username.trim().toLowerCase(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Create new user with email and password
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      // Check if username already exists
      if (username != null && username.isNotEmpty) {
        final existingEmail = await getEmailByUsername(username);
        if (existingEmail != null) {
          throw 'Tên người dùng đã được sử dụng';
        }
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Save user info to Firestore
      if (username != null && username.isNotEmpty) {
        await saveUserToFirestore(
          uid: credential.user!.uid,
          email: email,
          username: username,
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Handle Firebase Auth exceptions with Vietnamese messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này';
      case 'wrong-password':
        return 'Mật khẩu không đúng';
      case 'email-already-in-use':
        return 'Email đã được sử dụng bởi tài khoản khác';
      case 'invalid-email':
        return 'Địa chỉ email không hợp lệ';
      case 'weak-password':
        return 'Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn';
      case 'operation-not-allowed':
        return 'Đăng nhập bằng email/mật khẩu chưa được kích hoạt';
      case 'user-disabled':
        return 'Tài khoản này đã bị vô hiệu hóa';
      case 'too-many-requests':
        return 'Quá nhiều yêu cầu. Vui lòng thử lại sau';
      case 'invalid-credential':
        return 'Email hoặc mật khẩu không đúng';
      default:
        return 'Đã xảy ra lỗi: ${e.message}';
    }
  }
}
