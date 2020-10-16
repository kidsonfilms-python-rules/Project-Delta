import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class SubmitExtraDetails with ChangeNotifier {
  final String authToken;

  SubmitExtraDetails(this.authToken);

  Future<void> submit(String email, String utsavID, String name, String phoneNumber) async {
    // final url =
    //     'https://project-delta-db6b3.firebaseio.com/extra_details.json?auth=$authToken';
    int _index = 0;
    await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) => _index++);
    });
    //Btw most ridiculus peice (yes i know i spelled it wrong) of code ever
    await FirebaseFirestore.instance
        .collection("Schedule")
        .doc(email)
        .set({
      'name': 'nameController.text',
      'time': 'timeController.text',
      'index': _index
    });
  }
}
