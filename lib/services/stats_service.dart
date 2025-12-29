import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  /// Get number of books read (finished status)
  Future<int> getBooksReadCount() async {
    final uid = currentUserId;
    if (uid == null) return 0;

    try {
      final snapshot = await _firestore
          .collection('books')
          .where('userId', isEqualTo: uid)
          .where('readingStatus', isEqualTo: 'finished')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  /// Get total books in library
  Future<int> getTotalBooksCount() async {
    final uid = currentUserId;
    if (uid == null) return 0;

    try {
      final snapshot = await _firestore
          .collection('books')
          .where('userId', isEqualTo: uid)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  /// Get reading streak (consecutive days)
  Future<int> getReadingStreak() async {
    final uid = currentUserId;
    if (uid == null) return 0;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('readingActivities')
          .orderBy('date', descending: true)
          .limit(365)
          .get();

      if (snapshot.docs.isEmpty) return 0;

      int streak = 0;
      DateTime? lastDate;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final activityDate = (data['date'] as Timestamp?)?.toDate();
        
        if (activityDate == null) continue;

        final dateOnly = DateTime(activityDate.year, activityDate.month, activityDate.day);

        if (lastDate == null) {
          final today = DateTime.now();
          final todayOnly = DateTime(today.year, today.month, today.day);
          final diff = todayOnly.difference(dateOnly).inDays;
          
          if (diff > 1) return 0;
          streak = 1;
          lastDate = dateOnly;
        } else {
          final diff = lastDate.difference(dateOnly).inDays;
          if (diff == 1) {
            streak++;
            lastDate = dateOnly;
          } else {
            break;
          }
        }
      }

      return streak;
    } catch (e) {
      return 0;
    }
  }

  /// Record reading activity
  Future<void> recordReadingActivity({int minutesRead = 0}) async {
    final uid = currentUserId;
    if (uid == null) return;

    final now = DateTime.now();
    final dateId = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('readingActivities')
          .doc(dateId)
          .set({
        'date': Timestamp.fromDate(now),
        'minutesRead': FieldValue.increment(minutesRead),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      // Silently fail
    }
  }

  /// Get books read with details (for history)
  Future<List<Map<String, dynamic>>> getReadBooks() async {
    final uid = currentUserId;
    if (uid == null) return [];

    try {
      final snapshot = await _firestore
          .collection('books')
          .where('userId', isEqualTo: uid)
          .where('readingStatus', isEqualTo: 'finished')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'author': data['author'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
          'finishedAt': (data['updatedAt'] as Timestamp?)?.toDate(),
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get weekly reading minutes
  Future<List<int>> getWeeklyReadingMinutes() async {
    final uid = currentUserId;
    if (uid == null) return List.filled(7, 0);

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    try {
      final List<int> minutes = List.filled(7, 0);

      for (int i = 0; i < 7; i++) {
        final date = weekStart.add(Duration(days: i));
        final dateId = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        final doc = await _firestore
            .collection('users')
            .doc(uid)
            .collection('readingActivities')
            .doc(dateId)
            .get();

        if (doc.exists) {
          minutes[i] = (doc.data()?['minutesRead'] ?? 0) as int;
        }
      }

      return minutes;
    } catch (e) {
      return List.filled(7, 0);
    }
  }

  /// Get all reading stats
  Future<Map<String, dynamic>> getAllStats() async {
    final booksRead = await getBooksReadCount();
    final totalBooks = await getTotalBooksCount();
    final streak = await getReadingStreak();

    return {
      'booksRead': booksRead,
      'totalBooks': totalBooks,
      'readingStreak': streak,
    };
  }
}
