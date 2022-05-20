class Girdi{
  String ad;
  String soyad;
  int yas;
  String cinsiyet;
  String tarih;
  int boy;
  int kilo;
  String ilaclar;
  String rahatsizlik;

  Girdi(this.ad, this.soyad, this.yas, this.cinsiyet, this.tarih, this.boy, this.kilo, this.ilaclar,this.rahatsizlik);


  Girdi.fromMap(Map<String, dynamic> m) : this(
      m["ad"], m["soyad"], m["yas"], m["cinsiyet"], m["tarih"],m["boy"],m["kilo"], m["ilaclar"],m["rahatsizlik"]
  );

  Map toMap() {
    return{
      "ad" :ad ,
      "soyad" : soyad,
      "yas" : yas,
      "cinsiyet" : cinsiyet,
      "tarih": tarih,
      "boy": boy,
      "kilo": kilo,
      "ilaclar": ilaclar,
      "rahatsizlik": rahatsizlik,
    };
  }
}