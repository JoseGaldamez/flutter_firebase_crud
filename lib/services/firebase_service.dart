import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getPeople() async {
  List people = [];
  QuerySnapshot querySnapshot = await db.collection('people').get();
  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
    Map person = {
      "name": data["name"],
      "uid": doc.id,
    };

    people.add(person);
  }
  return people;
}

// Guardar un name en base de datos
Future<void> addPeople(String name) async {
  await db.collection("people").add({"name": name});
}

// Actualizar un name en base de datos
Future<void> updatePeople(String uid, String name) async {
  await db.collection("people").doc(uid).set({"name": name});
}

// Borrar datos de Firebase
Future<void> deletePeople(String uid) async {
  await db.collection("people").doc(uid).delete();
}
