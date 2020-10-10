import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'http_exception.dart';

class SubmitExtraDetails with ChangeNotifier {
  final String authToken;

  SubmitExtraDetails(this.authToken);

  Future<void> submit(String email, String utsavID, String name, String phoneNumber) async {
    final url =
        'https://project-delta-db6b3.firebaseio.com/extra_details.json?auth=$authToken';
    int _index = 0;
    await Firestore.instance
        .collection("users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => _index++);
    });
    //Btw most ridiculus peice (yes i know i spelled it wrong) of code ever
    await Firestore.instance
        .collection("Schedule")
        .document(email)
        .setData({
      'name': 'nameController.text',
      'time': 'timeController.text',
      'index': _index
    });
  }
}
