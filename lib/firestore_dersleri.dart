import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreDersleri extends StatelessWidget {
  FirestoreDersleri({super.key});

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // IDler
    debugPrint(_firestore.collection("users").id);
    debugPrint(_firestore
        .collection("users")
        .doc()
        .id); // add ile bir şey değiştirildiğinde farklı farklı idler oalrak gelerek değişiyor, her çalıştığında

    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore işlemleri"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                onPressed: () => veriEklemeAdd(),
                child: Text("Veri Ekleme Add")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade300),
                onPressed: () => veriEklemeSet(),
                child: Text("Veri Ekleme Set")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300),
                onPressed: () => veriSilme(),
                child: Text("Veri Silme")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300),
                onPressed: () => veriGuncelleme(),
                child: Text("Veri Guncelleme")),
          ],
        ),
      ),
    );
  }

  veriEklemeAdd() async {
    Map<String, dynamic> _eklenecekUser = Map<String, dynamic>();
    _eklenecekUser["isim"] = "menes";
    _eklenecekUser["yas"] = 23;
    _eklenecekUser["ogrenciMi"] = true;
    _eklenecekUser["adres"] = {"il": "bursa", "ilce": "kestel"};
    _eklenecekUser["renkler"] = FieldValue.arrayUnion(["turkuaz", "yesil"]);
    _eklenecekUser["createdAt"] = FieldValue.serverTimestamp();

    await _firestore.collection("users").add(_eklenecekUser);
  }

  veriEklemeSet() async {
    // veritabanında da ID değerini tutabilmek için
    var _yediDocId = _firestore.collection("users").doc().id;
    await _firestore
        .doc("users/$_yediDocId")
        .set({"isim": "menes", "userID": _yediDocId});

    Map<String, dynamic> _kullaniciyaBaskaOzellikEkleme =
        Map<String, dynamic>();
    _kullaniciyaBaskaOzellikEkleme["okul"] = "Bursa Uludag Universitesi";
    _kullaniciyaBaskaOzellikEkleme["yas"] = FieldValue.increment(
        1); // counter gibi çalışıyor. yas degerini alıcak +1 yaparak yerine koyacak
    await _firestore
        .doc("users/ixTTLxcObuTx4aPagpH0")
        .set(_kullaniciyaBaskaOzellikEkleme, SetOptions(merge: true));
  }

  veriSilme() async {}
  veriGuncelleme() async {}
}
