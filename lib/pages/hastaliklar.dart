import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proje_1_hasta_takip/pages/on_muayene_form.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( );
  runApp(Hastaliklar());
}
class Hastaliklar extends StatefulWidget {
  @override
  HastaliklarState createState() {
    return  HastaliklarState();
  }
}

class HastaliklarState extends State<Hastaliklar> {
  List<String> olanHastalik = [];
   Map<String, bool> hastalik = {
     "Anemi": false,
     "Astım": false,
     "Arterit": false,
     "Kanser": false,
     "Gut": false,
     "Diyabet": false,
     "Duygusal bozukluk": false,
     "Epilepsi nöbetleri": false,
     "Bayılma nöbetleri": false,
     "Safra taşı": false,
     "Kalp hastalığı": false,
     "Kalp krizi": false,
     "Romatizmal Ateş": false,
     "Yüksek Tansiyon": false,
     "Sindirim Problemleri": false,
     "Ülseratif Kolit": false,
     "Ülser Hastalığı": false,
     "Hepatit": false,
     "Böbrek Hastalığı": false,
     "Karaciğer hastalığı": false,
     "Uyku Apnesi": false,
     "Sürekli Pozitif Havayolu Basıncı Cihazı Kullanımı": false,
     "Tiroid Problemleri": false,
     "Tüberküloz": false,
     "Zührevi Hastalık": false,
     "Nörolojik Bozukluklar": false,
     "Kanama Bozuklukları": false,
     "Akciğer Hastalığı": false,
     "Anfizem": false
   };
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get check Value Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Geçirdiğiniz rahatsızlıkları seçiniz"),
            SizedBox(
              height: 400,
              child: ListView(
                shrinkWrap: true,
                      children:
                      hastalik.keys.map((String text) => CheckboxListTile(
                        title: Text(text),
                        value: hastalik[text],
                        onChanged: (val) {
                          setState(() {
                            hastalik[text] = val!;
                            if(hastalik[text] == true){
                              olanHastalik.add(text);
                            }
                            if(hastalik[text] == false){
                              olanHastalik.remove(text);
                            }

                          });
                        },
                      )).toList()
                    ),
            ),
            ElevatedButton(
                onPressed: (){
                  firestoreInstance.collection("hastaBilgi").doc(firebaseUser!.uid).set(
                      {
                       "Geçirilen rahatsılıklar":  olanHastalik
                      });
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const MuayeneForm()));
            }, child: const Text("Kaydet"))
          ],
        ),
      ),
    );
  }
}