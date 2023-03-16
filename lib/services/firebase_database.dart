import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class FirebaseHelper {
  final DatabaseReference _databaseReference;

  FirebaseHelper(this._databaseReference);

  Future<DatabaseEvent?> read(String path) async {
    DatabaseEvent? event;
    try {
      event = await _databaseReference.child(path).once();
    } catch (e) {
      // print('Failed to read data from Firebase: $e');
    }
    return event;
  }

  Future<void> write(String path, dynamic data) async {
    try {
      await _databaseReference.child(path).set(data);
    } catch (e) {
      // print('Failed to write data to Firebase: $e');
    }
  }

  Future<void> update(String path, Map<String, dynamic> data) async {
    try {
      await _databaseReference.child(path).update(data);
    } catch (e) {
      // print('Failed to update data on Firebase: $e');
    }
  }

  Future<void> delete(String path) async {
    try {
      await _databaseReference.child(path).remove();
    } catch (e) {
      // print('Failed to delete data from Firebase: $e');
    }
  }

  Stream<DataSnapshot?> readStream(String path) {
    return _databaseReference
        .child(path)
        .onValue
        .map((event) => event.snapshot);
  }

  Stream<void> updateStream(String path, Map<String, dynamic> data) {
    final reference = _databaseReference.child(path);
    return reference.onValue.asyncMap((event) async {
      if (event.snapshot.exists) {
        await reference.update(data);
      } else {
        await reference.set(data);
      }
    });
  }
}
