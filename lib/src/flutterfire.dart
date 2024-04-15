library flutter_fire;

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlutterFire {
  // Create instances of FirebaseAuth and FirebaseFirestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter for the current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream for auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // AUTHENTICATION
  // *************************************************************************
  // Method to sign out the user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // *************************************************************************
  // Method to sign in with Email and Password
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // *************************************************************************
  // Method to create user with Email and Password
  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // *************************************************************************
  // Method to sign in with Google
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // Get the GoogleSignInAuthentication
    final GoogleSignInAuthentication? gAuth = await gUser?.authentication;

    // Create a GoogleAuthProvider credential
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth?.accessToken,
      idToken: gAuth?.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
  }

  // FIREBASE FIRESTORE

  // *************************************************************************
  // Method to find a single document by ID
  Future findOne(collectionName, docId) async {
    Map<String, dynamic>? data = {};
    try {
      await _firestore.collection(collectionName).doc(docId).get().then((doc) {
        if (doc.exists) {
          data = doc.data();
        } else {
          if (kDebugMode) {
            print('Document $docId does not exist.');
          }
        }
        return doc;
      });
      if (data == {}) {
        return null;
      } else {
        return data;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching document $docId: $e');
      }

      return null;
    }
  }

  // *************************************************************************
  // Method to find a all documents in a collection
  Future findAll(collectionName) async {
    List documents = [];
    await _firestore.collection(collectionName).get().then((d) {
      for (var element in d.docs) {
        documents.add(element.data());
      }
    });

    if (documents == []) {
      return null;
    } else {
      return documents;
    }
  }

  // *************************************************************************
  // Get a stream data  from Firestore collection
  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamData(collectionName) =>
      _firestore.collection(collectionName).snapshots();

  getData(collectionName) {
    Map result = {};
    _firestore.collection(collectionName).get().then((value) {
      for (var element in value.docs) {
        result[element.id] = element.data();
      }
    });

    return result;
  }

  // *************************************************************************
  // Method to find a list documents that are present in a list of document IDs
  // and return them as a stream
  Stream<List<Map<String, dynamic>>> findStreamContainingList(
      collectionName, docId, listIds) async* {
    StreamController<List<Map<String, dynamic>>> controller =
        StreamController();

    List<Map<String, dynamic>> result = [];

    for (String documentId in listIds) {
      try {
        DocumentSnapshot documentSnapshot =
            await _firestore.collection(collectionName).doc(documentId).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          result.add(data);
        } else {
          if (kDebugMode) {
            print('Document $documentId does not exist.');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching document $documentId: $e');
        }
      }
    }

    // Add the result to the stream
    controller.add(result);

    // Close the stream
    controller.close();

    // Yield the stream
    yield* controller.stream;
  }
}
