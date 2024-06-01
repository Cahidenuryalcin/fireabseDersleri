import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//CRUD OPERATİON
//CREATE
//READ
//UPDATE
//DELETE

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
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade300),
                onPressed: () => veriOkuma(),
                child: Text("Veri Oku One Time")),
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

  //documan kullanılır, elemanlar gezilir
  // ixTTLxcObuTx4aPagpH0
  veriGuncelleme() async {
    // ilgili döküman varsa güncelleme işlemi yapacak
    await _firestore.doc("users/ixTTLxcObuTx4aPagpH0").update({
      "isim": "menescahide",
      "ogrenciMi": false,
      // olmayan bir alan varsa, özellik veya, onu oraya ekleyeme işlemi yapacak ör;
      // set işleminden farkı, update işlemi olması için documanı var  olması şart
      "medeniDurumu": "evli",

      // map kısımlarında ayrı ayrı erişim değiştirme mümkün;
      "adres.ilce": "balat",
    });
  }

  //documan kullanılır, elemanlar gezilir
  // ixTTLxcObuTx4aPagpH0
  veriSilme() async {
    // ilgili döküman varsa silme işlemi yapacak

    /* await _firestore
        .doc("users/ixTTLxcObuTx4aPagpH0").delete();
        //herhangi bir parametre istemeyecek, menes kişisiin tüm verileri siinecek
*/

    // update kullanarak silme gerçekleştirilebilmekte;
    await _firestore
        .doc("users/ixTTLxcObuTx4aPagpH0")
        .update({"okul": FieldValue.delete()});
  }

  veriOkuma() async{


    //collection

    var _userDocuments = await _firestore.collection("users").get();
    debugPrint(_userDocuments.size.toString()); //çıktı = 1        // tehlikeli bir işlem. 100bin kayıt  varsa 100 bin değerini elde etmem için 100bin okuma yaoması gerekecek.
    //ayrı bir collection ile bu işlemi tutarak da sayma işlemi yapılabilir
    // her user oluşturulduğunda counter +1 olmasını ayarlamak gibi

    debugPrint(_userDocuments.docs.length.toString()); //çıktı = 1

    for (var eleman in _userDocuments.docs) {
      debugPrint("Döküman ID ${eleman.id}"); // çıktı = Döküman ID jiNaSGcxDQXuwGObpdAX

      Map userMap= eleman.data();
      debugPrint(userMap["isim"]); // çıktı =  menes
      

    }


    //dokuman

    var _menesDoc = await _firestore.doc("users/jiNaSGcxDQXuwGObpdAX");

  }
}
