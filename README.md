<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# FLUTTER FIRE

This Flutter package, named `flutter_fire`, provides convenient and streamlined access to Firebase Authentication and Firestore operations within your Flutter applications. It simplifies tasks such as user authentication via email/password and Google Sign-In, as well as common Firestore operations like retrieving single documents, fetching all documents in a collection, and streaming data updates. With its intuitive methods, `flutter_fire` aims to enhance your development experience by seamlessly integrating Firebase services into your Flutter projects.

## Features

1. Authentication:
   - Sign in with email and password.
   - Create a new user with email and password.
   - Sign in with Google authentication.

2. Firebase Firestore Operations:
   - Find a single document by ID.
   - Find all documents in a collection.
   - Get a stream of data from a Firestore collection.
   - Retrieve data from a Firestore collection.
   - Find a list of documents present in a list of document IDs and return them as a stream.
3. Convenience Features:
   - Access to the current user.
   - Stream for authentication state changes.

## Getting started

### Prerequisites

1. **Flutter Setup:** Ensure you have Flutter installed on your system. You can find installation instructions on the official Flutter website.

2. **Firebase Account:** Create a Firebase account if you haven't already. You can sign up for free on the Firebase website.

```bat
@echo off

echo Firebase Login checking...
call firebase login
echo Adding Firebase plugins to the Flutter project...
call firebase init
echo Adding Firebase plugins to the Flutter project...
call flutter pub add firebase_core firebase_auth cloud_firestore
echo Running Flutter project...
call flutter run

```

To use this script, create a new text file in your project directory, name it firebase_init.bat, and paste the above code into it. Then, you can simply run this file from the command line to set up Firebase and add the necessary plugins to your Flutter project. Make sure you have both the Firebase CLI and Flutter installed and configured on your system before running this script.

## Usage

```dart
import 'package:flutter_fire/flutter_fire.dart';
```

**1. Authentication :**

```dart
// Initialize FlutterFire instance
FlutterFire flutterFire = FlutterFire();

// Sign in with email and password
await flutterFire.signInWithEmailAndPassword(email: 'example@email.com', password: 'password');

// Create a new user with email and password
await flutterFire.createUserWithEmailAndPassword(email: 'newuser@email.com', password: 'newpassword');

// Sign in with Google authentication
await flutterFire.signInWithGoogle();
```

**2. Firestore Operations :**

```dart
// Get a single document by ID
Map<String, dynamic>? document = await flutterFire.findOne('collectionName', 'documentId');

// Get all documents in a collection
List<dynamic>? documents = await flutterFire.findAll('collectionName');

// Stream data from a Firestore collection
Stream<QuerySnapshot<Map<String, dynamic>>> stream = flutterFire.getStreamData('collectionName');

// Retrieve data from a Firestore collection
Map<String, dynamic> data = flutterFire.getData('collectionName');

// Find documents present in a list of document IDs and return them as a stream
Stream<List<Map<String, dynamic>>> docStream = flutterFire.findStreamContainingList('collectionName', 'documentId', ['id1', 'id2']);

```

**3. Convenience Features:**

```dart
// Access the current user
User? currentUser = flutterFire.currentUser;

// Stream for authentication state changes
Stream<User?> authStream = flutterFire.authStateChanges;

```

These examples showcase how to perform common authentication and Firestore operations using the `flutter_fire` package, making it easier for developers to integrate Firebase services into their Flutter applications.

<td>
    <img src="">
</td>