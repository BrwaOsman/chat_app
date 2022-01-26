import 'package:cloud_firestore/cloud_firestore.dart';

class FireStor {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getDataUser(String? name) {
    if (name != null) {
       return _fireStore
        .collection("users")
        .where('firstName', isEqualTo: name)
        .snapshots();
      
    } else {
       return _fireStore
        .collection("users")
        .snapshots();
    }
   
  }
}
