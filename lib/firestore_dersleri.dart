import 'dart:async';

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

  StreamSubscription? _userSubscribe;

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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow.shade300),
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
                onPressed: () => veriOkumaOneTime(),
                child: Text("Veri Oku One Time")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade300),
                onPressed: () => veriOkumaRealTime(),
                child: Text("Veri Oku Real Time")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300),
                onPressed: () => streamDurdur(),
                child: Text("Stream Durdur")),
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade300),
                onPressed: () => batchKavrami(),
                child: Text("Batch Kavramı")),
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lime.shade300),
                onPressed: () => transactionKavrami(),
                child: Text("Transaction Kavramı")),
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

  veriOkumaOneTime() async {
    //collection

    var _userDocuments = await _firestore.collection("users").get();
    debugPrint(_userDocuments.size
        .toString()); //çıktı = 1        // tehlikeli bir işlem. 100bin kayıt  varsa 100 bin değerini elde etmem için 100bin okuma yaoması gerekecek.
    //ayrı bir collection ile bu işlemi tutarak da sayma işlemi yapılabilir
    // her user oluşturulduğunda counter +1 olmasını ayarlamak gibi

    debugPrint(_userDocuments.docs.length.toString()); //çıktı = 1

    for (var eleman in _userDocuments.docs) {
      debugPrint(
          "Döküman ID ${eleman.id}"); // çıktı = Döküman ID jiNaSGcxDQXuwGObpdAX

      Map userMap = eleman.data();
      debugPrint(userMap["isim"]); // çıktı =  menes
    }

    //dokuman

    var _menesDoc = await _firestore.doc("users/jiNaSGcxDQXuwGObpdAX").get();
    debugPrint(_menesDoc
        .data()
        .toString()); // çıktı =  {createdAt: Timestamp(seconds=1717274679, nanoseconds=767000000), ogrenciMi: true, renkler: [turkuaz, yesil], yas: 23, adres: {il: bursa, ilce: kestel}, isim: menes}
    debugPrint(_menesDoc.data()!["adres"]["il"].toString()); // çıktı = bursa
  }

  veriOkumaRealTime() async {
    //sürekli olarak dinleme (stream)
    var _userStream = await _firestore.collection("users").snapshots();
    //-  var _userDocStream = await _firestore.collection("users/jiNaSGcxDQXuwGObpdAX").snapshots();
    //- _userSubscribe = _userDocStream.listen((event){ // listen olduğundan users in her birini getiriyor , ilk tıklamada (butona bağladığımız için)
    //- debugPrint(event.data().toString());

    _userSubscribe = _userStream.listen((event) {


      //docChanges ile
      /* event.docChanges.forEach((element) {
        debugPrint(element.doc.data().toString()); //firestordan değişiklik yaptığımızda, bilgiyi güncelleyip konsola dökümanı yazar
      });
      */

      // dog ile
       event.docs.forEach((element) {
        debugPrint(element.data().toString());
      });
      
    });
  }
   
  // olmadı. çöz
  streamDurdur() async {
    await _userSubscribe?.cancel();
  }


  // ya hep ya hiç
  // TOPLU YAPILAN İŞLEMLER

  // 10 veri oluştururken bi hata sonucu 4 veri yazılıp 6 veri yazılamdığında, veri tutarsızlığı olur
  // bunu engellemek için batch kullanılır. gidecekse 10 veri gider gidemeyecekse hiçbiri gitmez
  
  batchKavrami() async{
   WriteBatch _batch = _firestore.batch();
/******* */ // bu ikisi arasınd ayapılan işlemler ya hep ya hiç oluyor.
  
  CollectionReference _counterColRef = _firestore.collection("counter");

/* batch ile eleman ekleme, bi hata olsaydı hiçbir şey eklemeyecekti, hata yoktu 99 tane counter ekledi firestora
  for (var i = 0; i < 100; i++) {
    var _yeniDoc = _counterColRef.doc();
    _batch.set(_yeniDoc, {"sayac": ++i, "id":_yeniDoc.id });

  }
 */ 

 var _counterDocs = await _counterColRef.get();


/***** */
   await _batch.commit();
  }
  transactionKavrami() async{

  }
}
