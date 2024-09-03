import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bayrak_quiz_uyg/SonucEkrani.dart';
import 'package:flutter_bayrak_quiz_uyg/models/Bayraklar.dart';
import 'package:flutter_bayrak_quiz_uyg/models/BayraklarDao.dart';

class Quizekrani extends StatefulWidget {
  const Quizekrani({super.key});

  @override
  State<Quizekrani> createState() => _QuizekraniState();
}

class _QuizekraniState extends State<Quizekrani> {
  var sorular = <Bayraklar>[];
  var yanlisSecenekler = <Bayraklar>[];
  Bayraklar? dogruSoru;
  var tumSecenekler = HashSet<Bayraklar>();

  int soruSayac = 0;
  int dogruSayac = 0;
  int yanlisSayac = 0;

  String bayrakResimAdi = "placeholder.png";
  String buttonAyazi = "";
  String buttonByazi = "";
  String buttonCyazi = "";
  String buttonDyazi = "";

  @override
  void initState() {
    super.initState();
    sorulariAl().then((_) => soruYukle());
  }

  Future<void> sorulariAl() async {
    sorular = await Bayraklardao().rastgele5Getir();
  }

  Future<void> soruYukle() async {
    if (sorular.isNotEmpty) {
      dogruSoru = sorular[soruSayac];

      bayrakResimAdi = dogruSoru!.bayrak_resim;

      yanlisSecenekler =
          await Bayraklardao().rastgele3YanlisGetir(dogruSoru!.bayrak_id);
      tumSecenekler.clear();
      tumSecenekler.add(dogruSoru!);
      tumSecenekler.addAll(yanlisSecenekler);

      // HashSet sırasız olduğu için elemanları karıştırır, bu yüzden burada kontrol etmelisiniz.
      var seceneklerListesi = tumSecenekler.toList();
      buttonAyazi = seceneklerListesi[0].bayrak_ad;
      buttonByazi = seceneklerListesi[1].bayrak_ad;
      buttonCyazi = seceneklerListesi[2].bayrak_ad;
      buttonDyazi = seceneklerListesi[3].bayrak_ad;
    } else {
      print('Sorular listesi boş.');
    }

    setState(() {});
  }

  void soruSayacKontrol() {
    soruSayac = soruSayac + 1;
    if (soruSayac != 5) {
      soruYukle();
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Sonucekrani(
                    dogruSayisi: dogruSayac,
                  )));
    }
  }

  void dogruKontrol(String butonYazi) {
    if (dogruSoru != null && dogruSoru!.bayrak_ad == butonYazi) {
      dogruSayac = dogruSayac + 1;
    } else {
      yanlisSayac = yanlisSayac + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          "Quiz Ekranı",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Doğru : $dogruSayac",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen),
                ),
                Text(
                  "Yanlış : $yanlisSayac",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                ),
              ],
            ),
            soruSayac != 5
                ? Text(
                    "${soruSayac + 1}. Soru",
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown),
                  )
                : const Text(
                    "5. Soru",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown),
                  ),
            Image.asset("resimler/$bayrakResimAdi"),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(buttonAyazi),
                onPressed: () {
                  dogruKontrol(buttonAyazi);
                  soruSayacKontrol();
                },
              ),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(buttonByazi),
                onPressed: () {
                  dogruKontrol(buttonByazi);
                  soruSayacKontrol();
                },
              ),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(buttonCyazi),
                onPressed: () {
                  dogruKontrol(buttonCyazi);
                  soruSayacKontrol();
                },
              ),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(buttonDyazi),
                onPressed: () {
                  dogruKontrol(buttonDyazi);
                  soruSayacKontrol();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
