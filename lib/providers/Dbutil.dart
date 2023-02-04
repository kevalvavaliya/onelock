import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Dbutil {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  // static Future<void> insertUSer(String name, String email) async {
  //   DocumentReference Dr =
  //       await db.collection("users").add({"name": name, "email": email});
  //   print(Dr.id);
  // }

  static Future<void> insertOffer(RTCSessionDescription offer) async {
    final messageRef = db.collection("users");
    final docref =
        messageRef.doc(FirebaseAuth.instance.currentUser!.email).set({
      "name": FirebaseAuth.instance.currentUser!.email,
      "email": FirebaseAuth.instance.currentUser!.email,
      "call": [],
    });

    print("AAAAAA" + docref.toString());

    // var offer = {
    //   "sdp": lp.sdp,
    //   "type": lp.type,
    // };

    // callDoc.set(offer.toMap());
    // var answerCandidates = callDoc.collection("answercandidates");
  }
}
