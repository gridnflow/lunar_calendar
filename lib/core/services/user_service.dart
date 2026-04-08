import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';

class UserService {
  final FirebaseFirestore _db;
  UserService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users => _db.collection('users');

  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserProfile.fromFirestore(doc.data()!);
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _users.doc(profile.uid).set(profile.toFirestore(), SetOptions(merge: true));
  }

  Future<bool> hasProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.exists && doc.data()?['birthYear'] != null;
  }

  Stream<UserProfile?> watchProfile(String uid) {
    return _users.doc(uid).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return UserProfile.fromFirestore(snap.data()!);
    });
  }

  Future<void> saveFcmToken(String uid, String token) async {
    await _users.doc(uid).set({'fcmToken': token}, SetOptions(merge: true));
  }

  Future<void> createFromGoogleUser(User user) async {
    final exists = await hasProfile(user.uid);
    if (exists) return;
    await _users.doc(user.uid).set({
      'uid': user.uid,
      'email': user.email ?? '',
      'displayName': user.displayName ?? '',
    }, SetOptions(merge: true));
  }
}
