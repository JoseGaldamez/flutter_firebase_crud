import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getPeople() async {
  List people = [];
  QuerySnapshot querySnapshot = await db.collection('people').get();
  for (var doc in querySnapshot.docs) {
    people.add(doc.data());
  }
  return people;
}

// Guardar un name en base de datos
Future<void> addPeople(String name) async {
  await db.collection("people").add({"name": name});
}
