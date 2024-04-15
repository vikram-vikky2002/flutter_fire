// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/src/flutter_fire.dart';
import 'package:loading_indicator/loading_indicator.dart';

class GoogleSigninButton extends StatelessWidget {
  GoogleSigninButton({super.key, this.extraFuntion});
  VoidCallback? extraFuntion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          FlutterFire().signInWithGoogle().whenComplete(() async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Scaffold(
                          backgroundColor: Colors.black,
                          body: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: LoadingIndicator(
                                    indicatorType:
                                        Indicator.ballClipRotateMultiple,
                                  ),
                                ),
                                Text(
                                  'Loading...',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )));
            User? user = FlutterFire().currentUser;
            extraFuntion!();
            try {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.email)
                  .get()
                  .then((doc) async {
                if (doc.exists) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.email)
                      .update({
                    'lastSignin': DateTime.now(),
                  });
                  if (kDebugMode) {
                    print("Exist..");
                  }
                } else {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.email)
                      .set({});
                  if (kDebugMode) {
                    print("New doc Created..");
                  }
                }
              });
            } on FirebaseException catch (error) {
              if (kDebugMode) {
                print("Errro : $error");
              }
            }

            Navigator.pop(context);
          });
        },
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  width: 60,
                  child: Image.asset('assets/icons/google.png'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  'Sign In with Google',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
