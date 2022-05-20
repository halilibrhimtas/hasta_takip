import 'package:flutter/material.dart';
import 'on_muayene_form.dart';


class Anasayfa extends StatelessWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anasayfa"),
      ),
      body: Column(
        children: [
          const Text("Hasta Takip Sistemine Hoşgeldiniz"),
          ElevatedButton(
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MuayeneForm()));
              },
              child:const Text("Ön Muayene Formu için Tıklayınız") )
        ],
      ),
    );
  }
}
