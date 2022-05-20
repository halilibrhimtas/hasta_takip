import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proje_1_hasta_takip/pages/kayit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proje_1_hasta_takip/pages/main.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0x42000000)
      ),
      home: const MyHomePage(title: 'Hasta Takip Sistemine Hoş Geldiniz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isFirebaseInitialized = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    setState(() {
      isFirebaseInitialized = true;
    });
  }

  @override
  Widget build( BuildContext context) {
    return Scaffold(

      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    icon: const Icon(Icons.person_rounded, color: Colors.purple),

                    hintText: "Kullanıcı adı giriniz",
                  filled: true,
                  fillColor: Colors.white70,
                  contentPadding: const EdgeInsets.only(
                      left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide:  const BorderSide(color: Colors.white),
                    borderRadius:  BorderRadius.circular(25.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:  const BorderSide(color: Colors.white),
                    borderRadius:  BorderRadius.circular(25.7),
                  ),
                ),
                style: const TextStyle(color: Colors.white70),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 8.0)),
              TextFormField(
                decoration: InputDecoration(
                    icon: const Icon(Icons.lock, color: Colors.purple),
                    filled: true,
                    hintText: "Şifrenizi giriniz",
                  fillColor: Colors.white70,
                  contentPadding: const EdgeInsets.only(
                      left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide:  const BorderSide(color: Colors.white),
                    borderRadius:  BorderRadius.circular(25.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:  const BorderSide(color: Colors.white),
                    borderRadius:  BorderRadius.circular(25.7),
                  ),

                ),
                style: const TextStyle(
                    color: Colors.white70,
                ),
                cursorColor: Colors.white70,
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.login), label: const Text("Giriş"),),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const KayitSayfasi()),
                  );
                },
                icon: const Icon(Icons.join_inner), label: const Text("Kayıt ol")),
             FlutterSocialButton(
                  onTap: () async {
                      final GoogleSignIn googleSignIn = GoogleSignIn();
                      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
                      if (googleSignInAccount != null) {
                        final GoogleSignInAuthentication googleSignInAuthentication =
                        await googleSignInAccount.authentication;
                        final AuthCredential authCredential = GoogleAuthProvider.credential(
                            idToken: googleSignInAuthentication.idToken,
                            accessToken: googleSignInAuthentication.accessToken);

                        // Getting users credential
                        UserCredential result = await auth.signInWithCredential(authCredential);

                        if (result != null) {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => const Anasayfa()));
                        }  // if result not null we simply call the MaterialpageRoute,
                        // for go to the HomePage screen
                      }


             }, buttonType: ButtonType.google, title: "Google ile giriş",),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Flexible(
                    child: IconButton(onPressed: null, icon: Icon(Icons.face),),
                    fit: FlexFit.tight,
                    flex: 1,
                  ),
                  Flexible(
                    child: IconButton(
                      onPressed: () {
                      },
                      icon: const Icon(Icons.fingerprint_outlined)),
                    fit: FlexFit.tight,
                    flex: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    }}

