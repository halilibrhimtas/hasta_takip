import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( );
  runApp(
    MaterialApp(
      title: "Ön Muayene Formu",
      home: const MuayeneForm(),
      theme: ThemeData.light().copyWith(inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder())),
      localizationsDelegates:  const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'), // Turkish
      ],)
);}

class MuayeneForm extends StatefulWidget {
  const MuayeneForm({Key? key}) : super(key: key);


  @override
  _MuayeneFormState createState() => _MuayeneFormState();
}

class _MuayeneFormState extends State<MuayeneForm> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ön Muayene Formu"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:  const [
              MuayeneBilgiFormu(),
            ],
          ),
        ),
      ),
    );
  }
}

class MuayeneBilgiFormu extends StatefulWidget {
  const MuayeneBilgiFormu({
    Key? key,
  }) : super(key: key);

  @override
  State<MuayeneBilgiFormu> createState() => _MuayeneBilgiFormuState();
}

class _MuayeneBilgiFormuState extends State<MuayeneBilgiFormu> {
  final Map<String, dynamic> girilen = {};
  final firestoreInstance = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  var firebaseUser =  FirebaseAuth.instance.currentUser;
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

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        child: Form(
          key:_formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                KisiselBilgiler(girilen: girilen),
                Hastaliklar(hastalik: hastalik, firestoreInstance: firestoreInstance, firebaseUser: firebaseUser, olanHastalik: olanHastalik),
                Aliskanliklar(girilen: girilen),
                FirebaseKayit(formKey: _formKey, firestoreInstance: firestoreInstance, firebaseUser: firebaseUser, girilen: girilen)
                  ],
                ),
          ),
        )
          );

  }

}

class Hastaliklar extends StatefulWidget {
  const Hastaliklar({
    Key? key,
    required this.hastalik,
    required this.firestoreInstance,
    required this.firebaseUser,
    required this.olanHastalik,
  }) : super(key: key);

  final Map<String, bool> hastalik;
  final FirebaseFirestore firestoreInstance;
  final User? firebaseUser;
  final List<String> olanHastalik;

  @override
  State<Hastaliklar> createState() => _HastaliklarState();
}

class _HastaliklarState extends State<Hastaliklar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text("Geçirdiğiniz rahatsızlıkları seçiniz"),
          SizedBox(
            height: 400,
            child: ListView(
                shrinkWrap: true,
                children:
                widget.hastalik.keys.map((String text) => CheckboxListTile(
                  title: Text(text),
                  value: widget.hastalik[text],
                  onChanged: (val) {
                    setState(() {
                      widget.hastalik[text] = val!;
                      if(widget.hastalik[text] == true){
                        widget.olanHastalik.add(text);
                      }
                      if(widget.hastalik[text] == false){
                        widget.olanHastalik.remove(text);
                      }

                    });
                  },
                )).toList()
            ),
          ),
          ElevatedButton(
              onPressed: (){
                widget.firestoreInstance.collection("hastaBilgi").doc(widget.firebaseUser!.uid).update(
                    {
                      "geçirilen rahatsızlıklar": widget.olanHastalik
                    });
              }, child: const Text("Kaydet"))
        ],
      ),
    );
  }
}

class KisiselBilgiler extends StatefulWidget {
   KisiselBilgiler({
    Key? key,
    required this.girilen,
  }) : super(key: key);

  final Map<String, dynamic> girilen;

  @override
  State<KisiselBilgiler> createState() => _KisiselBilgilerState();
}

class _KisiselBilgilerState extends State<KisiselBilgiler> {
  String? selectedDate;
  DateTime date = DateTime.now();
  DateFormat dateFormat = DateFormat("yyyy/MM/dd ");


  @override
  void initState() {
    selectedDate = dateFormat.format(date);
    super.initState();
   }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextFormField(
        //     decoration: InputDecoration(
        //     icon: const Icon(Icons.lock, color: Colors.purple),
        // filled: true,
        // hintText: "Şifrenizi giriniz",
        // fillColor: Colors.white70,
        // contentPadding: const EdgeInsets.only(
        //     left: 14.0, bottom: 8.0, top: 8.0),
        // focusedBorder: OutlineInputBorder(
        //   borderSide:  const BorderSide(color: Colors.white),
        //   borderRadius:  BorderRadius.circular(25.7),
        // ),
        // enabledBorder: UnderlineInputBorder(
        //   borderSide:  const BorderSide(color: Colors.white),
        //   borderRadius:  BorderRadius.circular(25.7),
        // ),)),
        TextFormField(
        decoration: const InputDecoration(
          labelText: "Ad",
          filled: true,
          fillColor: Colors.white70,
        ),
          validator: (value){
          if (value == null || value.isEmpty) {
            return 'Lütfen adınızı giriniz';
          }
          return null;
          },
          onSaved: (newValue){
          widget.girilen["ad"] = newValue!;
          },

              ),
    TextFormField(
      decoration: const InputDecoration(
          labelText: "Soyad"
      ),
      validator: (value){
        if (value == null || value.isEmpty) {
          return 'Lütfen adınızı giriniz';
        }
        return null;
      },
      onSaved: (newValue){
        widget.girilen["soyad"] = newValue!;
      },

    ),
            DropdownButtonFormField(
              hint: const Text("Cinsiyetinizi seçiniz"),
              items:  const [
                DropdownMenuItem(
                    child: Text("Kadın"),
                    value: "Kadın"),
                DropdownMenuItem(
                    child: Text("Erkek"),
                    value: "Erkek"),
              ],
                value: widget.girilen["cinsiyet"],
                onChanged: (value){
                setState(() {
                  widget.girilen["cinsiyet"] = value;
                });
                },
                validator: (value){
                if(value == null){
                  return "Lütfen cinsiyet seçiniz";
                }
              }),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Flexible(
                    fit: FlexFit.tight,
                    flex: 3,
                    child: Text("Doğum Tarihinizi giriniz")),
                Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          theme: const DatePickerTheme(
                              headerColor: Colors.grey,
                              backgroundColor: Colors.blue,
                              itemStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                              doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                          minTime: DateTime(1950, 3, 5),
                          maxTime: DateTime.now(),
                          onConfirm: (value) {
                            setState(() {
                              date = value;
                              selectedDate = dateFormat.format(date);
                              widget.girilen["tarih"] = selectedDate;
                            });

                            },
                          currentTime: DateTime.now(),
                          locale: LocaleType.tr,
                        );
                        },
                      icon: const Icon(Icons.calendar_today),)),
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child:  Text(
                      selectedDate!,
                      style: const TextStyle(color: Colors.blue),
                    )
                ),
              ],
            ),
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
              hintText: "Boy (cm)"
          ),
          onSaved: (value){
            widget.girilen["boy"] = value!;
            },
        ),
        TextFormField(
          decoration: const InputDecoration(
              hintText: "Kilo (kg)"
          ),
          onSaved: (value){
            widget.girilen["kilo"]= value!;
            },
        ),
        Container(
          margin: const EdgeInsets.all(8),
          height: 100.0,
          child:   TextFormField(
            maxLines:5,
            decoration: const InputDecoration(
              hintText: "Rahatsızlığınızı yazınız",
            ),
            onSaved: (value){
              widget.girilen["rahatsizlik"] = value!;
              },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          height: 100.0,
          child:  TextFormField(
            maxLines:5,
            decoration: const InputDecoration(
              hintText: "Kullandığınız ilaçları yazınız",
            ),
            onSaved: (value){
              widget.girilen["ilaclar"] = value!;
              },
          ),
        ),
      ]);
   }
}

class Aliskanliklar extends StatelessWidget {
  const Aliskanliklar({
    Key? key,
    required this.girilen,
  }) : super(key: key);

  final Map<String, dynamic> girilen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
            "Sağlıklı & Sağlıksız Alışkanlıklar",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20)
        ),
    FormBuilderRadioGroup(
        name:  "Egzersiz",
        decoration: const InputDecoration(
            labelText:"Egzersiz",
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)
        ),
        options: const [
          FormBuilderFieldOption(value: "Hiç"),
          FormBuilderFieldOption(value: "1-2 Gün"),
          FormBuilderFieldOption(value: "3-4 Gün"),
          FormBuilderFieldOption(value: "5+ Gün"),
        ],
      onSaved: (value){
          girilen["egzersiz"] = value;
      },
    ),
    FormBuilderRadioGroup(
        name:  "Diyet Programı",
        decoration: const InputDecoration(
            labelText:"Diyet Programı",
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)
        ),
        options: const [
          FormBuilderFieldOption(value: "Zayıf bir diyet yapıyorum"),
          FormBuilderFieldOption(value: "Sıkı bir diyet yapıyorum"),
          FormBuilderFieldOption(value: "Diyet planım yok"),
        ],
      onSaved: (value){
        girilen["diyet"] = value;
      },),
    FormBuilderRadioGroup(
        name:  "Alkol Tüketimi",
        decoration: const InputDecoration(
            labelText:"Alkol Tüketimi",
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)
        ),
        options: const [
          FormBuilderFieldOption(value: "Kullanmıyorum"),
          FormBuilderFieldOption(value: "1-2 bardak/gün"),
          FormBuilderFieldOption(value: "3-4 bardak/gün"),
          FormBuilderFieldOption(value: "5+ bardak/gün")
        ],
      onSaved: (value){
        girilen["alkol tüketimi"] = value;
      },),
    FormBuilderRadioGroup(
        name:  "Kafein Tüketimi",
        decoration: const InputDecoration(
            labelText:"Kafein Tüketimi",
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)
        ),
        options: const [
          FormBuilderFieldOption(value: "Kullanmıyorum"),
          FormBuilderFieldOption(value: "1-2 fincan/gün"),
          FormBuilderFieldOption(value: "3-4 fincan/gün"),
          FormBuilderFieldOption(value: "5+ fincan/gün"),
        ],
      onSaved: (value){
        girilen["kafein tüketimi"] = value;
      },),
    FormBuilderRadioGroup(
        name:  "Sigara tüketimi",
        decoration: const InputDecoration(
            labelText:"Sigara tüketimi",
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)
        ),
        options: const [
          FormBuilderFieldOption(value: "Kullanmıyorum"),
          FormBuilderFieldOption(value: "0-1 paket/gün"),
          FormBuilderFieldOption(value: "1-2 paket/gün"),
          FormBuilderFieldOption(value: "2+ paket/gün"),
        ],
      onSaved: (value){
        girilen["sigara tüketimi"] = value;
      },)]);
  }
}

class FirebaseKayit extends StatelessWidget {
  const FirebaseKayit({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.firestoreInstance,
    required this.firebaseUser,
    required this.girilen,
  }) : _formKey = formKey, super(key: key);

  final GlobalKey<FormState> _formKey;
  final FirebaseFirestore firestoreInstance;
  final User? firebaseUser;
  final Map<String, dynamic> girilen;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {
      final formState = _formKey.currentState;
      if(formState == null) return;
      if(formState.validate() == true){
        formState.save();
      }
      firestoreInstance.collection("hastaBilgi").doc(firebaseUser!.uid).set({
        "ad": girilen["ad"],
        "soyad": girilen["soyad"],
        "cinsiyet": girilen["cinsiyet"],
        "tarih": girilen["tarih"],
        "boy": girilen["boy"],
        "kilo": girilen["kilo"],
        "rahatsizlik": girilen["rahatsizlik"],
        "ilaclar": girilen["ilaclar"],
        "egzersiz": girilen["egzersiz"],
        "diyet": girilen["diyet"],
        "alkol tüketimi": girilen["alkol tüketimi"],
        "kafein tüketimi": girilen["kafein tüketimi"],
        "sigara tüketimi": girilen["sigara tüketimi"],
      }
          ).then((_){
        print("başarılı!");
      });
    },
        child: const Text("Kaydet"));
  }
}
