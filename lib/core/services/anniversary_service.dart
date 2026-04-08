import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/family_anniversary.dart';

class AnniversaryService {
  final FirebaseFirestore _db;

  AnniversaryService({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('anniversaries');

  Stream<List<FamilyAnniversary>> watchAnniversaries(String uid) {
    return _col(uid).snapshots().map((snap) {
      final list = snap.docs
          .map((d) => FamilyAnniversary.fromFirestore(d.id, d.data()))
          .toList();
      list.sort((a, b) {
        final m = a.lunarMonth.compareTo(b.lunarMonth);
        return m != 0 ? m : a.lunarDay.compareTo(b.lunarDay);
      });
      return list;
    });
  }

  Future<void> add(String uid, FamilyAnniversary ann) async {
    await _col(uid).add(ann.toFirestore());
  }

  Future<void> delete(String uid, String id) async {
    await _col(uid).doc(id).delete();
  }
}
