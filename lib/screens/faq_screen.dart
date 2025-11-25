import 'package:flutter/material.dart';

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});

  final List<FAQItem> faqList =  [
    FAQItem(
      question: "Uygulama hangi tür yerleri gösteriyor?",
      answer: "Uygulamamız, bulunduğunuz konuma yakın restoranlar, Alışveriş Merkezi, müzeler, kafeler gibi birçok kategorideki popüler yerleri gösterir.",
    ),
    FAQItem(
      question: "Konumumu nasıl güncelleyebilirim?",
      answer: "Ana ekranın üst kısmındaki konum ikonuna dokunarak veya harita üzerinde manuel olarak konumunuzu değiştirebilirsiniz.",
    ),
    FAQItem(
      question: "Listede olmayan bir yer önerebilir miyim?",
      answer: "Evet, 'Ayarlar' menüsü altından 'Yer Öner' seçeneği ile bize yeni mekan önerisi gönderebilirsiniz.",
    ),
    FAQItem(
      question: "Favori yerlerimi nasıl kaydederim?",
      answer: "Her mekanın detay sayfasındaki kalp (favori) ikonuna dokunarak kaydedebilirsiniz.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sık Sorulan Sorular"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: ListView.builder(
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final item = faqList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            elevation: 3,
            child: ExpansionTile(
              title: Text(
                item.question,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: Text(
                    item.answer,
                    style: const TextStyle(fontSize: 15.0),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}