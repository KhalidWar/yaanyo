import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yaanyo/models/shopping_grid.dart';
import 'package:yaanyo/models/shopping_task.dart';

class ShoppingService {
  final _shoppingGrid = FirebaseFirestore.instance
      .collection('shopping')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('shoppingGrid');

  Future<void> createNewShoppingGrid(ShoppingGrid shoppingGrid) async {
    _shoppingGrid.doc(shoppingGrid.storeName).set(shoppingGrid.toJson());
  }

  Stream<QuerySnapshot> getShoppingGridStream() {
    return _shoppingGrid.orderBy('time', descending: false).snapshots();
  }

  Future<void> addShoppingTask(
      String storeName, ShoppingTask shoppingTask) async {
    _shoppingGrid
        .doc(storeName)
        .collection('shoppingTask')
        .doc(shoppingTask.taskLabel)
        .set(shoppingTask.toJson());
  }

  Stream<QuerySnapshot> getShoppingTaskStream(String storeName) {
    return _shoppingGrid
        .doc(storeName)
        .collection('shoppingTask')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<void> toggleShoppingTask(
      ShoppingTask shoppingTask, String storeName) async {
    return await _shoppingGrid
        .doc(storeName)
        .collection('shoppingTask')
        .doc(shoppingTask.taskLabel)
        .update(shoppingTask.toJson());
  }

  Future<void> deleteShoppingGrid(
      String storeName, List<String> gridTasksList) async {
    /// deletes shoppingGrid document but does not delete its
    /// subcollections (shoppingTasks)
    /// https://firebase.google.com/docs/firestore/manage-data/delete-data
    _shoppingGrid.doc(storeName).delete().whenComplete(() {
      /// loop in gridTask list to delete every entry otherwise re-creating a shoppingGrid
      /// with same old name will show old gridTask items since they are exist
      for (String task in gridTasksList) {
        _shoppingGrid
            .doc(storeName)
            .collection('shoppingTask')
            .doc('$task')
            .delete();
      }
    });
  }

  Future<void> updateShoppingGrid(
      String storeName, ShoppingGrid shoppingGrid) async {
    await _shoppingGrid.doc(storeName).get().then((doc) {
      Map<String, dynamic> newData = {};

      if (doc.exists) {
        newData
          ..addAll(doc.data())
          ..update('storeName', (value) => shoppingGrid.storeName);
        _shoppingGrid.doc(shoppingGrid.storeName).set(shoppingGrid.toJson());
      }
    });
  }
}
