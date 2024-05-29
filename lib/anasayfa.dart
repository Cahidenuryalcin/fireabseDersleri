import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  late FirebaseAuth auth;
  final String _email = "cahidenuryalcin@gmail.com";
  final String _password = "cahide123";

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    // auth. dediğimizde özellikler çıkıyor

    //flutterfire dökümanı
    // signOutUser ile tetiklenir
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User oturumu kapalı!');
      } else {
        debugPrint(
            'User oturumu açık! ${user.email} ve email durumu ${user.emailVerified}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade200,
        title: Text(style: TextStyle(color: Colors.white), "Firebase Dersleri"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  createUserEmailAndPassword();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                    style: TextStyle(color: Colors.white),
                    "Email/Sifre Kayit")),
            ElevatedButton(
                onPressed: () {
                  loginUserEmailAndPassword();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                    style: TextStyle(color: Colors.white),
                    "Email/Sifre Giris")),
            ElevatedButton(
                onPressed: () {
                  signOutUser();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 1, 131, 40)),
                child: Text(
                    style: TextStyle(color: Colors.white), "Oturumu Kapat")),
            ElevatedButton(
                onPressed: () {
                  deleteUser();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 105, 5, 94)),
                child: Text(
                    style: TextStyle(color: Colors.white), "Kullaniciyi Sil")),
                                ElevatedButton(
                onPressed: () {
                  changePassword();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 163, 144, 0)),
                child: Text(
                    style: TextStyle(color: Colors.white), "Şifre Değiştir")),
                    ElevatedButton(
                onPressed: () {
                  changeEmail();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 243, 95, 226)),
                child: Text(
                    style: TextStyle(color: Colors.white), "Email Değiştir")),
          ],
        ),
      ),
    );
  }

  void createUserEmailAndPassword() async {
    try {
      var _userCredantial = await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      var _myUser = _userCredantial.user;

      if (!_myUser!.emailVerified) {
        _myUser.sendEmailVerification();
      } else {
        debugPrint("kullanici maili onaylandi, sayfaya yönlendirilebilir");
      }

      debugPrint(_userCredantial.toString());
    } catch (e) {
      debugPrint(e.toString());
      debugPrint("zaten böyle bir kullanıcı var");
    }
  }

  void loginUserEmailAndPassword() {
    try {
      var _userCredantial =
          auth.signInWithEmailAndPassword(email: _email, password: _password);
      debugPrint(_userCredantial.toString());
       debugPrint("kullanıcı giriş yapti");
    } catch (e) {
      //debugPrint(e.toString());
       debugPrint("önce kayit ol");
    }
  }

  void signOutUser() async {
    await auth.signOut();
     debugPrint("cikis yapildi");
  }
  
  void deleteUser() async{
    if (auth.currentUser!= null) {
       await auth.currentUser!.delete();
       debugPrint("kullanıcı silindi");
    }else{
      debugPrint("önce kayit ol ");
    }
   
  }
  
  void changePassword() async{
    try {
      await auth.currentUser!.updatePassword("cahide123");
      await auth.signOut();
    } on FirebaseAuthException catch(e){
      if (e.code== "requires-recent-login") {
        debugPrint("reauthenticate olacak");
        var credential = EmailAuthProvider.credential(email: _email, password: _password);
        await auth.currentUser!.reauthenticateWithCredential(credential);

        await auth.currentUser!.updatePassword("cahide123");
        await auth.signOut();
        debugPrint("şifre güncellendi");
        
      }
    }catch (e) {
      debugPrint(e.toString());
    }
    
  }
  
  // email değiştirme çalışmiy. çok da önemli değil şu anlik.
  void changeEmail() async{
    try {
      await auth.currentUser!.updateEmail("cnuryal@gmail.com");
      await auth.signOut();
    } on FirebaseAuthException catch(e){
      if (e.code== "requires-recent-login") {
        debugPrint("reauthenticate olacak");
        var credential = EmailAuthProvider.credential(email: _email, password: _password);
        await auth.currentUser!.reauthenticateWithCredential(credential);

        await auth.currentUser!.updateEmail("cnuryal@gmail.com");
        await auth.signOut();
        debugPrint("Email güncellendi");
        
      }
    }catch (e) {
      debugPrint(e.toString());
    }
  }



}
