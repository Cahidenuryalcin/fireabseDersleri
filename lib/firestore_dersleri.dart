import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreDersleri extends StatelessWidget {
  FirestoreDersleri({super.key});

  FirebaseFirestore _firestore= FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore işlemleri"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () => veriEklemeAdd(),
                child: Text("Veri Ekleme Add")),
                ElevatedButton(
                onPressed: () => veriEklemeSet(),
                child: Text("Veri Ekleme Set"))
          ],
        ),
      ),
    );
  }

  veriEklemeAdd() async {
   Map<String, dynamic> _eklenecekUser= Map<String, dynamic>();
   _eklenecekUser["isim"]= "cahide";
   _eklenecekUser["yas"]= 23;
   _eklenecekUser["ogrenciMi"]= false;
   await  _firestore.collection("users").add({

   })
  }
  
  veriEklemeSet() async{}
}
