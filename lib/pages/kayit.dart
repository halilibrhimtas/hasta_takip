
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:passwordfield/passwordfield.dart';

const appName = 'DateTimeField Example';
void main() => runApp(
    MaterialApp(
      title: appName,
      home: const KayitSayfasi(),
      theme: ThemeData.light().copyWith(inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder())),
      localizationsDelegates:  const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'), // Turkish
      ],)
    );

class KayitSayfasi extends StatefulWidget {
  const KayitSayfasi({Key? key}) : super(key: key);


  @override
  _KayitSayfasiState createState() => _KayitSayfasiState();

}

class _KayitSayfasiState extends State<KayitSayfasi> {

  late String selectedDate;
  DateTime date = DateTime.now();
  DateFormat dateFormat = DateFormat("yyyy/MM/dd ");
  @override
  void initState() {
    super.initState();
    selectedDate = dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: const Text("Kayıt Sayfası"),
       ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Adınız",
                  hintText: "Adınızı Giriniz",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Soyadınız",
                  hintText: "Soyadınızı Giriniz",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Yaş",
                  hintText: "Yaşınızı Giriniz",
                )
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Flexible(
                        fit: FlexFit.tight,
                          flex: 3,
                          child: Text("Doğum Tarihinizi giriniz")),
                      const Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: Icon(Icons.calendar_today)),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: TextButton(
                            onPressed: () {
                              DatePicker.showDatePicker(
                                  context,
                                  showTitleActions: true,
                                  theme:const DatePickerTheme(
                                      headerColor: Colors.grey,
                                      backgroundColor: Colors.blue,
                                      itemStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                      doneStyle:
                                      TextStyle(color: Colors.white, fontSize: 16)),
                                  minTime: DateTime(1950, 3, 5),
                                  maxTime: DateTime.now(),
                                  onConfirm: (value) {
                                    setState(() {
                                      date = value;
                                      selectedDate = dateFormat.format(date);
                                    });
                                  }, currentTime: DateTime.now(), locale: LocaleType.tr);
                            },
                            child:  Text(
                              selectedDate,
                              style: const TextStyle(color: Colors.blue),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Mail",
                    hintText: "Mail adresinizi giriniz",
                  )),
              PasswordField(
                  color: Colors.blue,
                  passwordConstraint: r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$' ,
                  inputDecoration: PasswordDecoration(),
                  hintText: 'Şifrenizi giriniz'),
              PasswordField(
                  color: Colors.blue,
                  passwordConstraint: r'.*[@$#.*].*',
                  inputDecoration: PasswordDecoration(),
                  hintText: 'Şifrenizi tekrar giriniz'),
            ],
          ),
        ),
      ),
    );
  }
}

