import 'package:flutter/material.dart';
import '../constants.dart';

class DataModel {
  // --- MEKANLAR LİSTESİ ---
  static final List<Map<String, dynamic>> items = [
    // ---------------------------------------------------------
    // 🎨 SANAT GALERİLERİ (ANKARA ÖZEL LİSTESİ) 🔥 YENİ EKLENDİ
    // ---------------------------------------------------------
    {
      'id': 400,
      'name': 'CerModern',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Sanat Galerisi',
      'description': 'Modern sanat sergileri, atölyeler ve açık hava sinemasıyla Ankara\'nın sanat kalbi.',
      'rating': 4.8,
      'location': 'Sıhhiye',
      'comments': [{'user': 'Sanatçı', 'text': 'Mekan tasarımı ve sergiler çok ilham verici.', 'rating': 5.0}],
    },
    {
      'id': 401,
      'name': 'Müze Evliyagil',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Sanat Galerisi',
      'description': 'İncek\'te, çağdaş sanat eserlerine ev sahipliği yapan, mimarisiyle büyüleyen özel müze ve galeri.',
      'rating': 4.9,
      'location': 'İncek',
      'comments': [{'user': 'Gezgin', 'text': 'Ankara\'da böyle bir yer olduğuna inanamadım, harika.', 'rating': 5.0}],
    },
    {
      'id': 402,
      'name': 'Galeri Siyah Beyaz',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Sanat Galerisi',
      'description': '1984\'ten beri ayakta olan, Ankara\'nın en köklü ve ikonik sanat galerisi. Alt katı efsanevi bir bardır.',
      'rating': 4.7,
      'location': 'Kavaklıdere',
      'comments': [{'user': 'Eski Müdavim', 'text': 'Hem sanat hem sohbet için en iyi adres.', 'rating': 5.0}],
    },
    {
      'id': 403,
      'name': 'Galeri Nev',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Sanat Galerisi',
      'description': 'Çağdaş Türk sanatının önde gelen isimlerinin eserlerini sergileyen prestijli galeri.',
      'rating': 4.6,
      'location': 'GOP (Kırlangıç Sokak)',
      'comments': [{'user': 'Koleksiyoner', 'text': 'Sergileri çok özenle seçiliyor.', 'rating': 4.0}],
    },
    {
      'id': 404,
      'name': 'Fikret Otyam Sanat Merkezi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Sanat Galerisi',
      'description': 'Çankaya Belediyesi\'ne ait, geniş sergi salonları ve modern mimarisiyle dikkat çeken sanat merkezi.',
      'rating': 4.5,
      'location': 'Çankaya',
      'comments': [{'user': 'Sanatsever', 'text': 'Çok ferah ve aydınlık bir galeri.', 'rating': 5.0}],
    },
    {
      'id': 405,
      'name': 'Ziraat Bankası Kuğulu Sanat Galerisi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Sanat Galerisi',
      'description': 'Tunalı Hilmi Caddesi\'nin kalbinde, Kuğulu Pasajı içinde yer alan tarihi galeri.',
      'rating': 4.4,
      'location': 'Kavaklıdere',
      'comments': [{'user': 'Tunalı Sakini', 'text': 'Yürüyüş yaparken uğramak çok keyifli.', 'rating': 4.0}],
    },
    {
      'id': 406,
      'name': 'Atlas Sanat Galerisi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Sanat Galerisi',
      'description': 'Cinnah Caddesi üzerinde, resim ve heykel sanatının seçkin örneklerinin sergilendiği galeri.',
      'rating': 4.5,
      'location': 'Çankaya',
      'comments': [{'user': 'Resim Sever', 'text': 'Sahipleri çok ilgili ve bilgili.', 'rating': 5.0}],
    },
    {
      'id': 407,
      'name': 'Platform A Sanat Galerisi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Sanat Galerisi',
      'description': 'Taurus AVM yanında, modern sanatçıların eserlerine yer veren geniş galeri.',
      'rating': 4.3,
      'location': 'Balgat',
      'comments': [{'user': 'Ziyaretçi', 'text': 'Ulaşımı çok kolay, sergiler başarılı.', 'rating': 4.0}],
    },
    {
      'id': 408,
      'name': 'Nurol Sanat Galerisi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Sanat Galerisi',
      'description': 'Güvenevler\'de bulunan, yıllardır sanatseverleri nitelikli eserlerle buluşturan galeri.',
      'rating': 4.4,
      'location': 'Güvenevler',
      'comments': [{'user': 'Sanat Dostu', 'text': 'Sessiz ve huzurlu bir ortam.', 'rating': 4.0}],
    },
    {
      'id': 409,
      'name': 'Valör Sanat Galerisi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Sanat Galerisi',
      'description': 'Yıldızevler\'de, klasik ve modern Türk resminin önemli temsilcilerini sergileyen galeri.',
      'rating': 4.5,
      'location': 'Yıldızevler',
      'comments': [{'user': 'Koleksiyoner', 'text': 'Eser seçkisi çok kaliteli.', 'rating': 5.0}],
    },
    {
      'id': 410,
      'name': 'Port Art Gallery',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Sanat Galerisi',
      'description': 'Portakal Çiçeği Vadisi manzaralı, genç sanatçılara da destek veren modern galeri.',
      'rating': 4.6,
      'location': 'Ayrancı',
      'comments': [{'user': 'Genç Sanatçı', 'text': 'Manzarası ve ortamı harika.', 'rating': 5.0}],
    },

    // ---------------------------------------------------------
    // 🎭 TİYATROLAR (Önceki Liste Korundu)
    // ---------------------------------------------------------
    {
      'id': 300,
      'name': 'Büyük Tiyatro',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Devlet Tiyatroları\'nın en büyük ve prestijli sahnesi.',
      'rating': 4.9,
      'location': 'Ulus',
      'comments': [{'user': 'Sanatsever', 'text': 'Locada oyun izlemek ayrı bir keyif.', 'rating': 5.0}],
    },
    {
      'id': 301,
      'name': 'Cüneyt Gökçer Sahnesi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Çayyolu\'nda bulunan, modern teknolojiyle donatılmış geniş kapasiteli devlet tiyatrosu sahnesi.',
      'rating': 4.8,
      'location': 'Çayyolu',
      'comments': [{'user': 'Tiyatrocu', 'text': 'Koltukları çok rahat, sahne görüşü mükemmel.', 'rating': 5.0}],
    },
    {
      'id': 302,
      'name': 'Şinasi Sahnesi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Tunalı Hilmi Caddesi üzerinde, Ankara\'nın en sevilen ve klasikleşmiş sahnelerinden biri.',
      'rating': 4.7,
      'location': 'Kavaklıdere',
      'comments': [{'user': 'Nostalji', 'text': 'Çocukluğum burada oyun izleyerek geçti.', 'rating': 5.0}],
    },
    {
      'id': 303,
      'name': 'Akün Sahnesi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Eski Akün Sineması\'ndan dönüştürülen, hem yetişkin hem çocuk oyunlarının sergilendiği sıcak atmosferli sahne.',
      'rating': 4.7,
      'location': 'Kavaklıdere',
      'comments': [{'user': 'Veli', 'text': 'Müzikalleri burada izlemek çok keyifli.', 'rating': 5.0}],
    },
    {
      'id': 304,
      'name': 'Küçük Tiyatro',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Ulus\'taki tarihi 2. Evkaf Apartmanı içinde yer alan, Ankara\'nın en eski sahnelerinden.',
      'rating': 4.6,
      'location': 'Ulus',
      'comments': [{'user': 'Tarih Meraklısı', 'text': 'Bina buram buram tarih kokuyor.', 'rating': 5.0}],
    },
    {
      'id': 305,
      'name': 'Tatbikat Sahnesi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Erdal Beşikçioğlu yönetiminde, yenilikçi ve cesur oyunların sergilendiği modern tiyatro.',
      'rating': 4.8,
      'location': 'Kavaklıdere',
      'comments': [{'user': 'Genç İzleyici', 'text': 'Farklı bir tiyatro deneyimi arayanlar için.', 'rating': 5.0}],
    },
    {
      'id': 306,
      'name': 'Ankara Sanat Tiyatrosu (AST)',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Yarım asrı aşkın süredir toplumsal gerçekçi oyunlarıyla bilinen efsanevi özel tiyatro.',
      'rating': 4.9,
      'location': 'Bilkent',
      'comments': [{'user': 'Eski Toprak', 'text': 'Ankara\'nın tiyatro okulu.', 'rating': 5.0}],
    },
    {
      'id': 307,
      'name': 'MEB Şura Salonu',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Beşevler\'de bulunan, büyük prodüksiyonlu oyunlara ve konserlere ev sahipliği yapan dev salon.',
      'rating': 4.3,
      'location': 'Beşevler',
      'comments': [{'user': 'Konser Sever', 'text': 'Akustiği fena değil, ulaşımı çok kolay.', 'rating': 4.0}],
    },
    {
      'id': 309,
      'name': 'Congresium Ankara',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Devasa sahnesiyle uluslararası müzikallere ve büyük gösterilere ev sahipliği yapan kongre merkezi.',
      'rating': 4.5,
      'location': 'Söğütözü',
      'comments': [{'user': 'Gösteri Tutkunu', 'text': 'Çok büyük ama sahne her yerden görünüyor.', 'rating': 4.0}],
    },
    {
      'id': 310,
      'name': 'Oda Tiyatrosu',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Küçük Tiyatro binasında bulunan, az seyirci kapasiteli samimi ve deneysel oyun sahnesi.',
      'rating': 4.5,
      'location': 'Ulus',
      'comments': [{'user': 'Minimalist', 'text': 'Oyuncularla iç içe oluyorsunuz.', 'rating': 5.0}],
    },
    {
      'id': 311,
      'name': 'İrfan Şahinbaş Atölye Sahnesi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Macunköy\'de bulunan, esnek sahne yapısıyla farklı oturma düzenlerine imkan veren deneysel sahne.',
      'rating': 4.7,
      'location': 'Macunköy',
      'comments': [{'user': 'Öğrenci', 'text': 'En sıra dışı oyunlar burada oluyor.', 'rating': 5.0}],
    },
    {
      'id': 312,
      'name': 'Kulis Sanat Tiyatrosu',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Bağımsız tiyatro topluluklarının oyunlarını sergilediği sıcak ve samimi bir sanat evi.',
      'rating': 4.4,
      'location': 'Batıkent',
      'comments': [{'user': 'Mahalleli', 'text': 'Semtimize sanat getirdiler.', 'rating': 5.0}],
    },
    {
      'id': 313,
      'name': '4 Mevsim Tiyatro Salonu',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Yenimahalle Belediyesi\'ne ait, yıl boyu çeşitli etkinliklerin düzenlendiği kültür merkezi.',
      'rating': 4.2,
      'location': 'Yenimahalle',
      'comments': [{'user': 'Vatandaş', 'text': 'Belediye etkinlikleri için güzel bir salon.', 'rating': 4.0}],
    },
    {
      'id': 314,
      'name': 'Çankaya Sahne',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Farabi Sokak\'ta, butik tiyatro sevenler için keyifli oyunlar sunan özel sahne.',
      'rating': 4.5,
      'location': 'Çankaya',
      'comments': [{'user': 'Tiyatrosever', 'text': 'Samimi bir ortamı var.', 'rating': 5.0}],
    },
    {
      'id': 315,
      'name': 'Bilkent Tiyatro Salonu',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Tiyatro',
      'description': 'Bilkent Üniversitesi Müzik ve Sahne Sanatları Fakültesi bünyesindeki profesyonel sahne.',
      'rating': 4.8,
      'location': 'Bilkent',
      'comments': [{'user': 'Öğrenci', 'text': 'Öğrenci oyunları bile profesyonel kalitede.', 'rating': 5.0}],
    },

    // ---------------------------------------------------------
    // 🎭 SANAT & KÜLTÜR YERLERİ (Müzeler ve Sinemalar - Korundu)
    // ---------------------------------------------------------
    {
      'id': 10,
      'name': 'Anadolu Medeniyetleri Müzesi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Müze',
      'description': 'Tarih öncesi çağlardan günümüze Anadolu tarihi.',
      'rating': 4.9,
      'location': 'Ulus',
      'comments': [{'user': 'Tarihçi B.', 'text': 'Mutlaka görülmesi gereken bir yer.', 'rating': 5.0}],
    },
    {
      'id': 102,
      'name': '1. TBMM (Kurtuluş Savaşı Müzesi)',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Müze',
      'description': 'Cumhuriyetin ilan edildiği ve İstiklal Marşı\'nın kabul edildiği ilk meclis binası.',
      'rating': 4.9,
      'location': 'Ulus',
      'comments': [{'user': 'Tarihçi', 'text': 'O günlerin ruhunu hissediyorsunuz.', 'rating': 5.0}],
    },
    {
      'id': 103,
      'name': '2. TBMM (Cumhuriyet Müzesi)',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Müze',
      'description': 'Atatürk ilke ve inkılaplarının yasalaştığı, modern Türkiye\'nin temellerinin atıldığı bina.',
      'rating': 4.8,
      'location': 'Ulus',
      'comments': [{'user': 'Öğrenci', 'text': 'Çok iyi korunmuş bir müze.', 'rating': 5.0}],
    },
    {
      'id': 108,
      'name': 'Etnografya Müzesi',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Müze',
      'description': 'Türk sanatının Selçuklu\'dan günümüze örneklerinin sergilendiği, Atatürk\'ün naaşının geçici istirahatgahı.',
      'rating': 4.8,
      'location': 'Sıhhiye',
      'comments': [{'user': 'Sanatsever', 'text': 'Mimari yapısı ve eserler çok etkileyici.', 'rating': 5.0}],
    },
    {
      'id': 112,
      'name': 'Rahmi M. Koç Müzesi (Çengelhan)',
      'category': '🎭 Sanat & Kültür Yerleri',
      'sub_category': 'Müze',
      'description': 'Kanuni Sultan Süleyman döneminden kalma tarihi handa kurulu sanayi müzesi.',
      'rating': 4.8,
      'location': 'Kale Altı',
      'comments': [{'user': 'Teknoloji Tutkunu', 'text': 'Çocuklarla gezmek için mükemmel.', 'rating': 5.0}],
    },


    // ---------------------------------------------------------
    // 🏛️ TARİHİ YERLER (Müzeler Hariç, Roma Hamamı Dahil)
    // ---------------------------------------------------------
    {
      'id': 100,
      'name': 'Anıtkabir',
      'category': '🏛️ Tarihi Yerler',
      'description': 'Türkiye Cumhuriyeti\'nin kurucusu Mustafa Kemal Atatürk\'ün anıt mezarı.',
      'rating': 5.0,
      'location': 'Çankaya',
      'comments': [{'user': 'Mehmet A.', 'text': 'Her Türk vatandaşının görmesi gereken yer.', 'rating': 5.0}],
    },
    {
      'id': 101,
      'name': 'Ankara Kalesi',
      'category': '🏛️ Tarihi Yerler',
      'description': 'Tarihi binlerce yıl öncesine dayanan, şehre hakim bir tepede bulunan kale.',
      'rating': 4.7,
      'location': 'Altındağ',
      'comments': [{'user': 'Gezgin', 'text': 'Manzarası muhteşem, sokakları tarih kokuyor.', 'rating': 5.0}],
    },
    {
      'id': 104,
      'name': 'Hacı Bayram Veli Camii',
      'category': '🏛️ Tarihi Yerler',
      'description': '1427 yılında inşa edilen, Ankara\'nın en önemli inanç ve tarih merkezlerinden biri.',
      'rating': 4.9,
      'location': 'Ulus',
      'comments': [{'user': 'Ahmet K.', 'text': 'Manevi atmosferi çok yüksek.', 'rating': 5.0}],
    },
    {
      'id': 105,
      'name': 'Augustus Tapınağı',
      'category': '🏛️ Tarihi Yerler',
      'description': 'Roma döneminden kalma, Hacı Bayram Camii\'nin bitişiğindeki tarihi tapınak.',
      'rating': 4.6,
      'location': 'Ulus',
      'comments': [{'user': 'Arkeolog', 'text': 'Roma ve İslam eserlerinin yan yana olması büyüleyici.', 'rating': 5.0}],
    },
    {
      'id': 106,
      'name': 'Roma Hamamı',
      'category': '🏛️ Tarihi Yerler',
      'description': '3. yüzyılda Roma İmparatoru Caracalla tarafından yaptırılan sağlık merkezi kalıntıları.',
      'rating': 4.4,
      'location': 'Ulus',
      'comments': [{'user': 'Ziyaretçi', 'text': 'Açık hava müzesi tadında.', 'rating': 4.0}],
    },
    {
      'id': 107,
      'name': 'Hamamönü',
      'category': '🏛️ Tarihi Yerler',
      'description': 'Restore edilmiş tarihi Ankara evleri, kafeler ve sanat sokağı.',
      'rating': 4.7,
      'location': 'Altındağ',
      'comments': [{'user': 'Fotoğrafçı', 'text': 'Fotoğraf çekmek için harika bir yer.', 'rating': 5.0}],
    },
    {
      'id': 109,
      'name': 'Julianus Sütunu',
      'category': '🏛️ Tarihi Yerler',
      'description': 'Roma İmparatoru Julianus\'un Ankara ziyareti onuruna 362 yılında dikilen sütun.',
      'rating': 4.3,
      'location': 'Ulus',
      'comments': [{'user': 'Meraklı', 'text': 'Şehrin ortasında bir tarih.', 'rating': 4.0}],
    },
    {
      'id': 110,
      'name': 'Gordion Antik Kenti',
      'category': '🏛️ Tarihi Yerler',
      'description': 'UNESCO Dünya Mirası listesindeki Frigya başkenti ve Kral Midas\'ın tümülüsü.',
      'rating': 4.9,
      'location': 'Polatlı',
      'comments': [{'user': 'Gezgin Ruhu', 'text': 'Biraz uzak ama kesinlikle görülmeye değer.', 'rating': 5.0}],
    },
    {
      'id': 111,
      'name': 'Ankara Palas',
      'category': '🏛️ Tarihi Yerler',
      'description': 'Cumhuriyet döneminin ilk yıllarına tanıklık etmiş, devlet konukevi olarak kullanılmış tarihi bina.',
      'rating': 4.6,
      'location': 'Ulus',
      'comments': [{'user': 'Tarih Meraklısı', 'text': 'İç mimarisi büyüleyici.', 'rating': 5.0}],
    },

    // ---------------------------------------------------------
    // 🛍️ ALIŞVERİŞ (AVM Listesi Aynen Korundu)
    // ---------------------------------------------------------
    // ---------------------------------------------------------
    // 🛍️ ALIŞVERİŞ (YENİ KATAGORİ DÜZENİ: AVM vs ÇARŞI)
    // ---------------------------------------------------------

    // === GRUP 1: Alışveriş Merkezi (AVM'ler) ===
    // ---------------------------------------------------------
    // 🛍️ ALIŞVERİŞ (GÜNCELLENDİ: KATEGORİLİ MAĞAZA LİSTESİ)
    // ---------------------------------------------------------

    // === GRUP 1: ALIŞVERİŞ MERKEZLERİ ===
    // ---------------------------------------------------------
    // 🛍️ ALIŞVERİŞ (GÜNCELLENDİ: KATEGORİLİ MAĞAZA LİSTESİ)
    // ---------------------------------------------------------

    // === GRUP 1: ALIŞVERİŞ MERKEZLERİ ===
    {
      'id': 200,
      'name': 'Ankamall AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Türkiye\'nin en büyük alışveriş merkezlerinden biri. 300\'den fazla mağaza ve 5M Migros ile tam bir çekim merkezi.',
      'rating': 4.5,
      'location': 'Akköprü',
      // 🔥 YENİ YAPI: KATEGORİLİ MAP
      'brand_categories': {
        'Giyim & Moda': [
          'Zara', 'H&M', 'Boyner', 'Bershka', 'Pull&Bear', 'Stradivarius', 'Oysho', 'Massimo Dutti',
          'Mango', 'Lacoste', 'Tommy Hilfiger', 'Gant', 'Network', 'Beymen Club', 'Ramsey',
          'İpekyol', 'Twist', 'Yargıcı', 'Mavi', 'LC Waikiki', 'DeFacto', 'Koton', 'Colin\'s',
        ],
        'Spor & Outdoor': [
          'Adidas', 'Nike', 'Under Armour', 'Skechers', 'Decathlon', 'Superstep', 'Sneaks Up',
        ],
        'Teknoloji & Kitap': [
          'MediaMarkt', 'Teknosa', 'Samsung', 'Troy (Apple)', 'Xiaomi', 'Turkcell', 'Vodafone', 'D&R',
        ],
        'Ev & Yaşam & Çocuk': [
          'English Home', 'Madame Coco', 'Karaca', 'Bernardo', 'Tefal', 'Jumbo', 'Zara Home',
          'Toyzz Shop', 'Ebebek', 'Mothercare', 'Koçtaş Fix',
        ],
        'Kozmetik & Aksesuar': [
          'Sephora', 'MAC', 'Gratis', 'Watsons', 'Yves Rocher', 'Atasay', 'Zen Pırlanta',
          'Saat&Saat', 'Swatch', 'Pandora', 'So Chic', 'Victoria\'s Secret Beauty'
        ],
        'Yeme & İçme & Eğlence': [
          'Starbucks', 'Kahve Dünyası', 'Big Chefs', 'Midpoint', 'Cookshop', 'Happy Moon\'s',
          'HD İskender', 'Burger King', 'McDonald\'s', 'KFC', 'Popeyes', 'Paribu Cineverse', 'MacFit',
        ],
        'Hipermarket & Hizmet': ['5M Migros', 'Dry Clean Express', 'Terzi', 'Eczane'],
      },
      'comments': [{'user': 'Alışverişkolik', 'text': 'Aradığım her marka var, otoparkı devasa.', 'rating': 5.0}],
    },
    {
      'id': 201,
      'name': 'Panora AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Oran\'da lüks markaları, dev akvaryumu ve ferah peyzajıyla seçkin bir alışveriş deneyimi.',
      'rating': 4.7,
      'location': 'Oran',
      'brand_categories': {
        'Lüks & Giyim': [
          'Beymen', 'Vakko', 'Vakkorama', 'Burberry', 'Hugo Boss', 'Emporio Armani', 'Rolex',
          'Network', 'Beymen Club', 'Massimo Dutti', 'Lacoste', 'Gant', 'Nautica', 'Marks & Spencer',
          'Zara', 'H&M', 'Mango', 'Yargıcı', 'İpekyol', 'Gap',
        ],
        'Kozmetik & Bakım': [
          'Sephora', 'MAC', 'Jo Malone', 'Kiehl\'s', 'L\'Occitane', 'Aveda',
        ],
        'Yeme & Gurme': [
          'Timboo Cafe', 'Midpoint', 'Quick China', 'SushiCo', 'NumNum', 'Big Chefs',
          'Godiva', 'Starbucks', 'Butterfly Chocolate', 'Mezzaluna', 'Uludağ Kebapçısı', 'Kirpi Cafe',
        ],
        'Market & Ev': [
          'Macrocenter', 'Paşabahçe', 'Chakra', 'Yataş Bedding', 'Zara Home',
        ],
        'Eğlence & Spor': ['Cinemaximum Gold Class', 'MacFit', 'Göl Akvaryum', 'Joy Park'],
        'Teknoloji': ['Samsung', 'Apple Yetkili Satıcı', 'D&R', 'Huawei'],
        'Aksesuar': ['Saat&Saat', 'Pandora', 'Altınbaş'],
      },
      'comments': [{'user': 'Zeynep S.', 'text': 'Peyzaj alanı çok ferah, kalabalıktan uzak.', 'rating': 5.0}],
    },
    {
      'id': 202,
      'name': 'Armada AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': '"Armada Hayat Sokağı" ile ünlü, ofis ve alışverişi birleştiren açık hava konseptli AVM.',
      'rating': 4.6,
      'location': 'Söğütözü',
      'brand_categories': {
        'Giyim & Moda': [
          'Vakkorama', 'Beymen Club', 'Network', 'Zara', 'Massimo Dutti', 'Oysho',
          'Calvin Klein', 'Tommy Hilfiger', 'U.S. Polo Assn.', 'İpekyol', 'Twist',
          'Yargıcı', 'Mavi', 'Mudo', 'Abdullah Kiğılı', 'Damat Tween',
        ],
        'Yeme & İçme & Yaşam Sokağı': [
          'Hayat Sokağı (Konsept)', 'Downtown Food Club', 'Timboo', 'Louise', 'Big Chefs',
          'Vapiano', 'Starbucks Reserve', 'Caribou Coffee', 'Beyaz Fırın', 'Midpoint',
        ],
        'Market & Ev': ['Macrocenter', 'Paşabahçe', 'Zara Home', 'English Home', 'Madame Coco'],
        'Diğer & Hizmet': [
          'D&R', 'Samsonite', 'Tumi', 'Saat&Saat', 'Cinemaximum', 'Armada Spor Merkezi',
          'Kuru Temizleme', 'Eczane', 'Terzi',
        ],
        'Teknoloji': ['Teknosa', 'MediaMarkt', 'Apple Yetkili Satıcı'],
      },
      'comments': [{'user': 'İş Dünyası', 'text': 'Öğle yemekleri ve iş çıkışı için ideal.', 'rating': 4.0}],
    },
    {
      'id': 203,
      'name': 'Kentpark AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Arkasındaki göleti, açık hava alanları ve dev spor mağazalarıyla popüler.',
      'rating': 4.4,
      'location': 'Eskişehir Yolu',
      'brand_categories': {
        'Giyim & Moda': [
          'Beymen', 'Vakko', 'Marks & Spencer', 'GAP', 'Banana Republic', 'Massimo Dutti',
          'Zara', 'Mango', 'Mudo Concept', 'Lacoste', 'Gant', 'Calzedonia', 'Intimissimi', 'Penti',
        ],
        'Spor & Outdoor': ['Decathlon (Çok Büyük)', 'Nike', 'Adidas', 'Hummel'],
        'Teknoloji & Ev': [
          'MediaMarkt', 'Teknosa', 'Kipa (Migros)', 'English Home', 'Madame Coco', 'Crate & Barrel (Eski)',
        ],
        'Yeme & İçme & Eğlence': [
          'Tab Gıda (Food Court)', 'Big Chefs', 'Timboo', 'NumNum', 'Kitchenette', 'Mado',
          'Starbucks', 'Caribou', 'Cinemaximum', 'Gölet Kenarı Kafeler'
        ],
        'Kozmetik & Aksesuar': ['Sephora', 'MAC', 'Gratis', 'Watsons', 'Saat&Saat'],
      },
      'comments': [{'user': 'Aile Babası', 'text': 'Çocuklar parka bayılıyor, Decathlon çok büyük.', 'rating': 4.0}],
    },
    {
      'id': 204,
      'name': 'CEPA AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Kentpark\'ın hemen yanında, Bauhaus ve geniş marka karmasıyla pratik AVM.',
      'rating': 4.3,
      'location': 'Eskişehir Yolu',
      'brand_categories': {
        'Yapı Market & Hipermarket': ['Bauhaus', 'CarrefourSA (Büyük)', 'Koçtaş'],
        'Giyim & Moda': [
          'Boyner', 'H&M', 'Koton', 'LC Waikiki', 'DeFacto', 'Mavi', 'Loft', 'Lufian',
          'Twist', 'İpekyol', 'Yargıcı', 'Hatemoğlu',
        ],
        'Spor & Ayakkabı': ['Adidas', 'Nike', 'Skechers', 'Puma', 'Deichmann'],
        'Teknoloji & Ev': [
          'D&R', 'Teknosa', 'MediaMarkt', 'Toyzz Shop', 'Ebebek', 'English Home', 'Madame Coco',
        ],
        'Yeme & Eğlence': [
          'Paribu Cineverse', 'Rolling Ball Bowling', 'Playland',
          'Starbucks', 'Kahve Dünyası', 'Tavuk Dünyası', 'HD İskender', 'Pidem'
        ],
      },
      'comments': [{'user': 'Öğrenci', 'text': 'Sineması çok rahat, Bauhaus için geliyoruz.', 'rating': 4.0}],
    },
    {
      'id': 205,
      'name': 'Atakule',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Ankara\'nın simgesi. Botanik Park manzaralı terasları ve butik lüks mağazaları.',
      'rating': 4.8,
      'location': 'Çankaya',
      'brand_categories': {
        'Gastronomi & Cafe': [
          'Luigi\'s Ristorante', 'Louise Brasserie', 'Zoie', 'Caffè Nero', 'Timboo Cafe',
          'The House Cafe', 'Starbucks', 'Fiolas', 'Quick China (Butik)',
        ],
        'Lüks Butik & Giyim': [
          'Vakkorama', 'Beymen Club', 'Network', 'Lacoste', 'Gant', 'Yargıcı', 'Arcadia', 'Tory Burch',
        ],
        'Market & Hizmet': [
          'Macrocenter', 'Cinemaximum', 'GymFit', 'Dry Clean', 'Eczane', 'Terzi', 'Teras Gözlem Alanı',
        ],
      },
      'comments': [{'user': 'Romantik', 'text': 'Teras manzarası harika, restoranlar çok şık.', 'rating': 5.0}],
    },
    {
      'id': 206,
      'name': 'Gordion AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Çayyolu bölgesinin en popüler, ödüllü "Yeşil AVM"si. Metro bağlantısı mevcut.',
      'rating': 4.5,
      'location': 'Çayyolu',
      'brand_categories': {
        'Giyim & Moda': [
          'Zara', 'Bershka', 'Stradivarius', 'Pull&Bear', 'Oysho', 'Massimo Dutti',
          'H&M', 'Mango', 'Network', 'Beymen Club', 'Benetton', 'Mavi', 'Twist', 'İpekyol',
        ],
        'Ev & Yaşam': ['Zara Home', 'Madame Coco', 'English Home', 'Karaca', 'Paşabahçe'],
        'Teknoloji & Eğlence': [
          'MediaMarkt', 'Cinemaximum', 'D&R', 'Teknosa', 'Samsung', 'Turkcell',
        ],
        'Yeme & İçme': [
          'Cookshop', 'Big Chefs', 'Midpoint', 'Starbucks', 'Caribou', 'Godiva',
        ],
        'Hipermarket': ['CarrefourSA Gurme', 'Macrocenter'],
      },
      'comments': [{'user': 'Semt Sakini', 'text': 'Sakin, nezih ve metroyla ulaşım çok kolay.', 'rating': 5.0}],
    },
    {
      'id': 207,
      'name': 'Arcadium AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Çayyolu\'nun butik ve samimi alışveriş merkezi.',
      'rating': 4.2,
      'location': 'Çayyolu',
      'brand_categories': {
        'Giyim & Moda': [
          'Boyner', 'Koton', 'Mavi', 'İpekyol', 'Twist', 'Yargıcı', 'Defacto', 'LC Waikiki',
        ],
        'Ev & Yaşam': ['English Home', 'Madame Coco', 'Paşabahçe', 'Mudo Concept'],
        'Teknoloji & Market': ['Teknosa', 'Migros', 'D&R', 'Samsung'],
        'Yeme & Eğlence': ['Sinema', 'Starbucks', 'Özsüt', 'Burger King', 'Pidem', 'Kafeler'],
      },
      'comments': [{'user': 'Kitap Kurdu', 'text': 'D&R mağazası çok büyük.', 'rating': 4.0}],
    },
    {
      'id': 208,
      'name': 'Next Level AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Söğütözü\'nde modern mimarisi, sanat galerisi ve lüks restoranlarıyla dikkat çeken AVM.',
      'rating': 4.4,
      'location': 'Söğütözü',
      'brand_categories': {
        'Giyim & Lüks': [
          'Vakkorama', 'Network', 'Tommy Hilfiger', 'Calvin Klein', 'Massimo Dutti', 'İpekyol',
        ],
        'Kozmetik & Aksesuar': [
          'Victoria\'s Secret', 'Jo Malone', 'Kiehl\'s', 'Sephora', 'MAC', 'Pandora',
        ],
        'Teknoloji & Hizmet': [
          'Dyson (Deneyim Mağazası)', 'Macrocenter', 'Cinemaximum', 'Ziraat Sanat Galerisi',
        ],
        'Yeme & Gurme': [
          'Big Chefs', 'Kırıntı', 'Keifi', 'Godiva', 'Masa Restaurant', 'Starbucks',
        ],
      },
      'comments': [{'user': 'Gurme', 'text': 'Restoranları çok kaliteli, sessiz bir AVM.', 'rating': 4.0}],
    },
    {
      'id': 209,
      'name': 'Taurus AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Konya Yolu üzerinde, kolay ulaşılabilir ve ferah bir AVM. Dijital altyapısıyla ünlü.',
      'rating': 4.1,
      'location': 'Balgat',
      'brand_categories': {
        'Giyim & Moda': [
          'H&M', 'Koton', 'LC Waikiki', 'DeFacto', 'Mavi', 'Mango', 'Flo', 'Deichmann',
        ],
        'Teknoloji & Eğlence': [
          'Teknosa', 'Samsung', 'Cinemarine', 'D&R', 'E-Bebek', 'Toyzz Shop', 'Playland',
        ],
        'Market & Yeme': [
          'Migros', 'Burger King', 'KFC', 'Starbucks', 'Tavuk Dünyası', 'Pidem', 'Köfteci Ramiz',
        ],
      },
      'comments': [{'user': 'Ahmet K.', 'text': 'Otoparkı çok rahat, trafiğe girmeden gidiliyor.', 'rating': 4.0}],
    },
    {
      'id': 210,
      'name': 'Kızılay AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Şehrin tam kalbinde, metro çıkışında bulunan dikey mimarili buluşma noktası.',
      'rating': 3.9,
      'location': 'Kızılay',
      'brand_categories': {
        'Giyim & Moda': [
          'Mavi', 'Koton', 'LC Waikiki', 'Flo', 'DeFacto', 'Defacto Fit', 'Penti',
        ],
        'Kozmetik & Aksesuar': [
          'Gratis', 'Watsons', 'Rossmann', 'Miniso', 'Saat&Saat', 'Atasay',
        ],
        'Yeme & İçme': [
          'Burger King', 'Popeyes', 'Kahve Dünyası', 'Simit Sarayı', 'Starbucks (Teras)',
        ],
        'Teknoloji & Kitap': ['Teknosa', 'D&R', 'Turkcell'],
      },
      'comments': [{'user': 'Aceleci', 'text': 'Metro çıkışında olması hayat kurtarıyor.', 'rating': 4.0}],
    },
    {
      'id': 211,
      'name': 'Optimum Outlet',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Eryaman bölgesinde, büyük markaların seri sonu ve indirimli mağazalarıyla ünlü.',
      'rating': 4.3,
      'location': 'Eryaman',
      'brand_categories': {
        'Outlet Giyim & Moda': [
          'Vakko Outlet', 'Beymen Outlet', 'Boyner Outlet', 'Mavi Outlet', 'LC Waikiki',
          'Defacto', 'Koton', 'Derimod Depo', 'Flo Outlet', 'Penti', 'Twist',
        ],
        'Outlet Spor': [
          'Nike Factory Store', 'Adidas Outlet', 'Puma Outlet', 'Skechers Outlet', 'Under Armour Outlet',
        ],
        'Hipermarket & Eğlence': [
          'Migros', 'Koçtaş', 'Avşar Sinemaları', 'Starbucks', 'Tavuk Dünyası',
        ],
      },
      'comments': [{'user': 'İndirim Avcısı', 'text': 'Fiyatlar gerçekten uygun, ayakkabı için ideal.', 'rating': 4.0}],
    },
    {
      'id': 212,
      'name': 'ACity Outlet',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'İstanbul Yolu üzerinde, "Premium Outlet" konseptli, çok geniş marka karmasına sahip AVM.',
      'rating': 4.2,
      'location': 'Yenimahalle',
      'brand_categories': {
        'Outlet Giyim & Moda': [
          'Beymen Business Outlet', 'Network Outlet', 'Altınyıldız', 'Kiğılı', 'Pierre Cardin',
          'LC Waikiki', 'Flo', 'Derimod', 'Hatemoğlu', 'Sarar', 'Boyner Outlet',
        ],
        'Outlet Spor & Outdoor': [
          'Nike Factory', 'Adidas', 'Under Armour', 'Columbia', 'Salomon', 'Jack Wolfskin',
        ],
        'Teknoloji & Eğlence': ['MediaMarkt', 'Cineipol Sinemaları', 'Playland'],
        'Yeme & İçme': ['Pidem', 'KFC', 'Burger King', 'Teras Yemek Alanı'],
      },
      'comments': [{'user': 'Haftasonu Gezgini', 'text': 'Erkek giyim ve spor mağazaları çok çeşitli.', 'rating': 4.0}],
    },
    {
      'id': 213,
      'name': 'Nata Vega Outlet',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'İçinde dev akvaryum (Aqua Vega), IKEA ve büyük mobilya mağazaları bulunan kompleks.',
      'rating': 4.1,
      'location': 'Mamak',
      'brand_categories': {
        'Ev & Yapı': ['IKEA (Yan Bina)', 'Metro Market', 'Enza Home', 'Doğtaş', 'Yataş'],
        'Giyim & Outlet': [
          'Nike Factory', 'Adidas Outlet', 'Mavi', 'LC Waikiki', 'Koton', 'Flo', 'Defacto',
        ],
        'Eğlence & Diğer': [
          'Aqua Vega Akvaryum', 'MediaMarkt', 'Teknosa', 'Cinemaximum', 'Starbucks',
        ],
      },
      'comments': [{'user': 'Çocuklu Aile', 'text': 'Akvaryum ve IKEA turu için tam günlük aktivite.', 'rating': 4.0}],
    },
    {
      'id': 214,
      'name': 'Metromall AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Eryaman\'ın en büyük, üstü açılabilen modern alışveriş merkezi. Metro durağı önünde.',
      'rating': 4.6,
      'location': 'Eryaman',
      'brand_categories': {
        'Giyim & Moda': [
          'Zara', 'H&M', 'Bershka', 'Pull&Bear', 'Stradivarius', 'Oysho',
          'Boyner', 'LC Waikiki', 'Koton', 'Mavi', 'Twist', 'İpekyol',
        ],
        'Spor & Teknoloji': [
          'Decathlon', 'Sporjinal', 'MediaMarkt', 'Teknosa', 'Samsung',
        ],
        'Market & Yeme': [
          'Migros', 'Cinemaximum', 'Starbucks', 'Arabica', 'Big Chefs', 'Midpoint',
        ],
        'Ev & Yaşam': ['English Home', 'Madame Coco', 'Karaca'],
      },
      'comments': [{'user': 'Eryamanlı', 'text': 'Bölgenin en iyisi.', 'rating': 5.0}],
    },
    {
      'id': 215,
      'name': 'Atlantis AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Batıkent\'in eğlence ve alışveriş merkezi. Monoray ve açık alanlarıyla ünlü.',
      'rating': 4.2,
      'location': 'Batıkent',
      'brand_categories': {
        'Giyim & Yaşam': [
          'Migros', 'LC Waikiki', 'Koton', 'Mavi', 'Penti', 'English Home', 'Flo',
        ],
        'Eğlence & Teknoloji': [
          'Teknosa', 'Joy Park (Eğlence)', 'Atlantis Sinemaları', 'Bowling', 'Playland',
        ],
        'Yeme & İçme': ['Burger King', 'Starbucks', 'Kafeler', 'Restoranlar'],
      },
      'comments': [{'user': 'Gençlik', 'text': 'Monoray çok havalı, terasları güzel.', 'rating': 4.0}],
    },
    {
      'id': 216,
      'name': 'Antares AVM',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Alışveriş Merkezi',
      'description': 'Etlik bölgesinde, geniş koridorları ve bowling salonuyla bilinen AVM.',
      'rating': 4.0,
      'location': 'Etlik',
      'brand_categories': {
        'Giyim & Moda': [
          '5M Migros', 'C&A', 'LC Waikiki', 'Koton', 'DeFacto', 'Mavi', 'Boyner',
        ],
        'Teknoloji & Eğlence': [
          'Flo', 'Teknosa', 'MediaMarkt', 'Cinemaximum', 'Bowling Salonu', 'Playland',
        ],
        'Yeme & İçme': ['Fast Food zincirleri', 'Restoranlar', 'Kahve Zincirleri'],
      },
      'comments': [{'user': 'Mahalleli', 'text': 'Ferah bir yer.', 'rating': 3.0}],
    },
    // ... (Bundan sonra Çarşı & Pazar & Cadde kısmı gelmeli, onu koru)
    // ... (Diğer tüm AVM'ler (203 - 216) ve Çarşı/Pazar/Tarihi Yerler de aynı şekilde 'brand_categories' yapısına dönüştürülmeli.)

    // === GRUP 2: ÇARŞI & PAZAR (Tarihi, Cadde, Pazar) ===
    {
      'id': 220,
      'name': 'Samanpazarı & Çıkrıkçılar',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Çarşı & Pazar & Cadde',
      'description': 'Geleneksel el sanatları, bakırcılar, antikacılar ve baharatçıların olduğu tarihi bölge. Gerçek Ankara ruhunu hissettirir.',
      'rating': 4.7,
      'location': 'Ulus / Kale Altı',
      // 🔥 KATEGORİLİ YAPI
      'brand_categories': {
        'Geleneksel & El Sanatları': ['Bakırcılar', 'Gümüşçüler', 'Kumaşçılar', 'Yöresel Dokumalar'],
        'Antika & Koleksiyon': ['Antikacılar', 'Eski Eşya Dükkanları', 'Plakçılar (Bazı Hanlar)'],
        'Gıda & Baharat': ['Baharatçılar', 'Şifalı Ot Satıcıları', 'Yöresel Ürünler'],
        'Dinlenme Alanı': ['Gramofon Kafe', 'Tarihi Çay Ocakları'],
      },
      'comments': [{'user': 'Turist', 'text': 'Gerçek Ankara ruhu burada.', 'rating': 5.0}],
    },
    {
      'id': 221,
      'name': 'Suluhan Çarşısı',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Çarşı & Pazar & Cadde',
      'description': 'Osmanlı döneminden kalma tarihi han. Boncuk, takı malzemeleri ve süs eşyaları cenneti.',
      'rating': 4.5,
      'location': 'Ulus',
      // 🔥 KATEGORİLİ YAPI
      'brand_categories': {
        'Hobi & Aksesuar Malzemeleri': ['Boncukçular', 'Takı Malzemecileri', 'Deri İpleri', 'Yüncü Mağazaları'],
        'Etkinlik & Süsleme': ['Süs Eşyası', 'Nikah Şekeri Malzemeleri', 'Yapay Çiçekçiler', 'Kurdele Mağazaları'],
        'Geleneksel Satıcılar': ['Tarihi Çay Ocağı', 'Geleneksel Bıçakçılar'],
      },
      'comments': [{'user': 'Hobi Sever', 'text': 'Takı yapmak isteyenler için cennet.', 'rating': 5.0}],
    },
    {
      'id': 222,
      'name': 'Tunalı Hilmi Caddesi',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Çarşı & Pazar & Cadde',
      'description': 'Ankara\'nın en ünlü ve canlı caddesi. Lüks butikler, pasajlar ve kaliteli kafeler.',
      'rating': 4.6,
      'location': 'Kavaklıdere',
      // 🔥 KATEGORİLİ YAPI
      'brand_categories': {
        'Moda & Giyim': ['Mavi', 'Mango', 'Benetton', 'Butikler', 'Ayakkabıcılar'],
        'Kozmetik & Yaşam': ['Mac', 'Sephora', 'Gratis', 'Watsons', 'Paşabahçe'],
        'Kültür & Pasajlar': ['D&R', 'Kitapçılar', 'Kuğulu Pasajı (Butikler)', 'Ertuğ Pasajı'],
        'Yeme & İçme': ['Starbucks', 'Kafeler', 'Restoranlar', 'Tunalı Pastanesi'],
      },
      'comments': [{'user': 'Gezgin', 'text': 'Hem alışveriş hem yürüyüş için harika.', 'rating': 5.0}],
    },
    {
      'id': 223,
      'name': 'Limon Bazaar',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Çarşı & Pazar & Cadde',
      'description': 'Kızılay\'da uygun fiyatlı kıyafet, aksesuar ve hediyelik eşya bulabileceğiniz popüler bir pasaj. (Kızılay Pasajı)',
      'rating': 4.0,
      'location': 'Kızılay',
      // 🔥 KATEGORİLİ YAPI
      'brand_categories': {
        'Giyim & Aksesuar': ['Butik Giyimciler', 'Çantacılar', 'Takıcılar', 'Ucuz Kozmetik'],
        'Hizmet & Teknoloji': ['Telefon Kılıfçıları', 'Tamirciler', 'Piercing Stüdyoları'],
        'Hediyelik': ['Hediyelik Eşya', 'Poster Dükkanları'],
      },
      'comments': [{'user': 'Öğrenci', 'text': 'Çok ucuz ve çeşit bol.', 'rating': 4.0}],
    },
    {
      'id': 224,
      'name': 'Ayrancı Antika Pazarı',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Çarşı & Pazar & Cadde',
      'description': 'Her ayın ilk Pazar günü kurulan, nostaljik eşyaların, plakların ve antikaların satıldığı meşhur pazar.',
      'rating': 4.8,
      'location': 'Ayrancı',
      // 🔥 KATEGORİLİ YAPI
      'brand_categories': {
        'Koleksiyon & Antika': ['Antika Eşya', 'Plakçılar', 'Eski Kitapçılar', 'Koleksiyoncular Tezgahları'],
        'Nostaljik Eşya': ['Retro Giyim', 'Vintage Mobilya', 'Eski Oyuncaklar'],
        'Sanat & Hobi': ['El Yapımı Takılar', 'Resim Satıcıları', 'Sanatçı Tezgahları'],
        'Yeme & İçme': ['Kahve ve Atıştırmalık Tezgahları'],
      },
      'comments': [{'user': 'Koleksiyoner', 'text': 'Erken gitmek lazım, harika parçalar var.', 'rating': 5.0}],
    },
    {
      'id': 225,
      'name': 'Bahçelievler 7. Cadde',
      'category': '🛍️ Alışveriş',
      'sub_category': 'Çarşı & Pazar & Cadde',
      'description': 'Gençlerin uğrak noktası, mağazalar ve kafelerle dolu canlı bir cadde.',
      'rating': 4.5,
      'location': 'Bahçelievler',
      // 🔥 KATEGORİLİ YAPI
      'brand_categories': {
        'Giyim & Spor': ['Mavi', 'Adidas', 'Nike', 'Watsons', 'Gratis', 'Butik Giyim Mağazaları'],
        'Yeme & İçme': ['Starbucks', 'Kafeler', 'Burger Mekanları', 'Tatlıcılar'],
        'Kültür & Yaşam': ['Kitapçılar', 'Kırtasiyeler', 'Aksesuar Mağazaları'],
      },
      'comments': [{'user': 'Üniversiteli', 'text': 'Akşamları çok hareketli.', 'rating': 5.0}],
    },

    // ---------------------------------------------------------
    // 🍴 YEME & İÇME YERLERİ (Aynen Korundu)
    // ---------------------------------------------------------
    {
      'id': 1,
      'name': 'Velvet Coffee House',
      'category': '🍴 Yeme & İçme Yerleri',
      'sub_category': 'Cafe',
      'description': '3. nesil kahve deneyimi ve huzurlu bir çalışma ortamı.',
      'rating': 4.8,
      'location': 'Bahçelievler',
      'menu': [{'name': 'Latte', 'price': 65}, {'name': 'Cheesecake', 'price': 90}],
      'comments': [{'user': 'Ayşe K.', 'text': 'Kahveleri harika!', 'rating': 5.0}],
      'details': ['Wi-Fi', 'Dış Mekan'],
    },
    {
      'id': 2,
      'name': 'Rumeli Çikolatacısı',
      'category': '🍴 Yeme & İçme Yerleri',
      'sub_category': 'Tatlı & Pastane',
      'description': 'Geleneksel tatlılar ve eşsiz çikolatalar.',
      'rating': 4.5,
      'location': 'Tunalı Hilmi',
      'menu': [{'name': 'Sıcak Çikolata', 'price': 80}, {'name': 'Fıstıklı Çikolata', 'price': 120}],
      'comments': [{'user': 'Mehmet T.', 'text': 'Çok kalabalık ama değer.', 'rating': 4.0}],
    },
    {
      'id': 3,
      'name': 'Liva Pastanesi',
      'category': '🍴 Yeme & İçme Yerleri',
      'sub_category': 'Tatlı & Pastane',
      'description': 'Yılların değişmeyen lezzeti, taze pastalar.',
      'rating': 4.3,
      'location': 'Çankaya',
      'menu': [{'name': 'Yaş Pasta (Dilim)', 'price': 95}, {'name': 'Ekler', 'price': 40}],
      'comments': [{'user': 'Selin B.', 'text': 'Doğum günü pastalarım hep buradan.', 'rating': 5.0}],
    },
    {
      'id': 4,
      'name': 'Burger King',
      'category': '🍴 Yeme & İçme Yerleri',
      'sub_category': 'Fast Food',
      'description': 'Hızlı ve doyurucu hamburger menüleri.',
      'rating': 3.8,
      'location': 'Kızılay',
      'menu': [{'name': 'Whopper Menü', 'price': 180}, {'name': 'Soğan Halkası', 'price': 40}],
      'comments': [{'user': 'Caner D.', 'text': 'Servis biraz yavaştı.', 'rating': 3.0}],
    },
    {
      'id': 5,
      'name': 'Masabaşı Kebapçısı',
      'category': '🍴 Yeme & İçme Yerleri',
      'sub_category': 'Türk Mutfağı',
      'description': 'Geleneksel Türk kebapları ve pideleri.',
      'rating': 4.7,
      'location': 'Balgat',
      'menu': [{'name': 'Adana Kebap', 'price': 280}, {'name': 'Lahmacun', 'price': 70}],
      'comments': [{'user': 'Ahmet Y.', 'text': 'Adanası efsane.', 'rating': 5.0}],
    },
    {
      'id': 6,
      'name': 'Quick China',
      'category': '🍴 Yeme & İçme Yerleri',
      'sub_category': 'Dünya Mutfağı',
      'sub_sub_category': 'Çin Mutfağı',
      'description': 'Ankara’nın en sevilen Çin restoranı.',
      'rating': 4.6,
      'location': 'Tepe Prime',
      'menu': [{'name': 'Sushi Set', 'price': 350}, {'name': 'Noodle', 'price': 220}],
      'comments': [{'user': 'Ceren S.', 'text': 'Sushi severler için tek adres.', 'rating': 5.0}],
    },
    {
      'id': 7,
      'name': 'SushiCo',
      'category': '🍴 Yeme & İçme Yerleri',
      'sub_category': 'Dünya Mutfağı',
      'sub_sub_category': 'Japon Mutfağı',
      'description': 'Orijinal Japon lezzetleri.',
      'rating': 4.4,
      'location': 'GOP',
      'menu': [{'name': 'California Roll', 'price': 240}, {'name': 'Miso Çorbası', 'price': 90}],
      'comments': [{'user': 'Burak K.', 'text': 'Fiyatlar biraz yüksek ama lezzetli.', 'rating': 4.0}],
    },
    {
      'id': 8,
      'name': 'Mezzaluna',
      'category': '🍴 Yeme & İçme Yerleri',
      'sub_category': 'Dünya Mutfağı',
      'sub_sub_category': 'İtalyan Mutfağı',
      'description': 'Gerçek İtalyan pizzası ve makarnaları.',
      'rating': 4.7,
      'location': 'Bilkent Center',
      'menu': [{'name': 'Pizza Margherita', 'price': 320}, {'name': 'Tiramisu', 'price': 150}],
      'comments': [{'user': 'Zeynep A.', 'text': 'Ambiyans çok şık.', 'rating': 5.0}],
    },
    {
      'id': 9,
      'name': 'Las Chicas',
      'category': '🍴 Yeme & İçme Yerleri',
      'sub_category': 'Dünya Mutfağı',
      'sub_sub_category': 'Meksika Mutfağı',
      'description': 'Acı ve baharatın buluştuğu Meksika lezzetleri.',
      'rating': 4.2,
      'location': 'Bahçelievler',
      'menu': [{'name': 'Taco', 'price': 180}, {'name': 'Burrito', 'price': 200}],
      'comments': [{'user': 'Emre V.', 'text': 'Sosları çok güzeldi.', 'rating': 4.0}],
    },

    // ---------------------------------------------------------
    // 🏞️ DİĞER KATEGORİLER
    // ---------------------------------------------------------
    // ---------------------------------------------------------
    // 🏞️ DOĞA & PARKLAR (İsim Güncellendi)
    // ---------------------------------------------------------
    {
      'id': 500,
      'name': 'Kuğulu Park',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Ankara\'nın simgesi. Kuğuları, asırlık ağaçları ve Tunalı\'nın kalbindeki konumuyla vazgeçilmez bir dinlenme noktası.',
      'rating': 4.8,
      'location': 'Kavaklıdere',
      'comments': [{'user': 'Ankaralı', 'text': 'Kışın karda, yazın gölgede oturmak ayrı güzel.', 'rating': 5.0}],
    },
    {
      'id': 501,
      'name': 'Seğmenler Parkı',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Geniş çim alanları, amfitiyatrosu ve köpek dostu yapısıyla gençlerin favori buluşma noktası.',
      'rating': 4.9,
      'location': 'Çankaya',
      'comments': [{'user': 'Üniversiteli', 'text': 'Sandalyeni al gel, ortam çok rahat.', 'rating': 5.0}],
    },
    {
      'id': 502,
      'name': 'Eymir Gölü',
      'category': '🏞️ Doğa & Parklar',
      'description': 'ODTÜ arazisi içinde, şehirden uzaklaşmadan doğa yürüyüşü ve bisiklet turu yapabileceğiniz harika bir göl.',
      'rating': 4.9,
      'location': 'Gölbaşı / ODTÜ',
      'comments': [{'user': 'Bisikletçi', 'text': 'Göl kenarında bisiklet sürmek terapi gibi.', 'rating': 5.0}],
    },
    {
      'id': 503,
      'name': 'Dikmen Vadisi',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Sakura ağaçları, süs havuzları ve kilometrelerce süren yürüyüş parkurlarıyla devasa bir rekreasyon alanı.',
      'rating': 4.7,
      'location': 'Dikmen',
      'comments': [{'user': 'Doğa Sever', 'text': 'Özellikle baharda kiraz çiçekleri açınca büyüleyici oluyor.', 'rating': 5.0}],
    },
    {
      'id': 504,
      'name': 'Mogan Gölü (Gölbaşı)',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Gün batımının en güzel izlendiği, piknik alanları ve sahil yoluyla ünlü büyük göl parkı.',
      'rating': 4.6,
      'location': 'Gölbaşı',
      'comments': [{'user': 'Aile', 'text': 'Hafta sonu kahvaltısı ve yürüyüş için ideal.', 'rating': 4.0}],
    },
    {
      'id': 505,
      'name': 'Gençlik Parkı',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Cumhuriyet tarihinin en eski parkı. İçinde lunapark, tiyatrolar ve dev bir havuz bulunuyor.',
      'rating': 4.5,
      'location': 'Ulus',
      'comments': [{'user': 'Nostalji', 'text': 'Akşam ışıklandırmalarıyla çok güzel.', 'rating': 4.0}],
    },
    {
      'id': 506,
      'name': 'Botanik Parkı',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Atakule\'nin hemen altında, sessiz, sakin ve bol yeşillikli huzur dolu bir park.',
      'rating': 4.8,
      'location': 'Çankaya',
      'comments': [{'user': 'Kitap Kurdu', 'text': 'Kitap okumak için şehrin en sessiz köşesi.', 'rating': 5.0}],
    },
    {
      'id': 507,
      'name': 'Göksu Parkı',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Eryaman\'da bulunan, göl kenarındaki iskeleleri, kafeleri ve aktivite alanlarıyla çok popüler bir park.',
      'rating': 4.6,
      'location': 'Eryaman',
      'comments': [{'user': 'Semt Sakini', 'text': 'Akşam yürüyüşleri için vazgeçilmez.', 'rating': 5.0}],
    },
    {
      'id': 508,
      'name': 'Ahlatlıbel Atatürk Parkı',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Çankaya Belediyesi\'ne ait, uçurtma tepeleri ve uygun fiyatlı kafeteryalarıyla bilinen geniş park.',
      'rating': 4.8,
      'location': 'İncek',
      'comments': [{'user': 'Çocuklu Aile', 'text': 'Çimlere yayılmak ve uçurtma uçurmak için süper.', 'rating': 5.0}],
    },
    {
      'id': 509,
      'name': 'Altınpark',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Bilim merkezi, fuar alanı, göleti ve seralarıyla Ankara\'nın en büyük parklarından biri.',
      'rating': 4.4,
      'location': 'Aydınlıkevler',
      'comments': [{'user': 'Gezgin', 'text': 'İçindeki Feza Gürsey Bilim Merkezi çocuklar için harika.', 'rating': 4.0}],
    },
    {
      'id': 510,
      'name': 'Mavi Göl (Bayındır Barajı)',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Şehirden biraz uzakta, özellikle mangal ve piknik yapmak isteyenlerin tercih ettiği geniş su kenarı.',
      'rating': 4.3,
      'location': 'Mamak / Kayaş',
      'comments': [{'user': 'Piknikçi', 'text': 'Hafta sonu çok kalabalık oluyor ama manzarası güzel.', 'rating': 4.0}],
    },
    {
      'id': 511,
      'name': 'Harikalar Diyarı',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Avrupa\'nın en büyük parklarından biri. Masal kahramanları heykelleriyle çocuklar için bir cennet.',
      'rating': 4.5,
      'location': 'Sincan',
      'comments': [{'user': 'Ebeveyn', 'text': 'Çocuklar bayılıyor, gez gez bitmiyor.', 'rating': 5.0}],
    },
    {
      'id': 512,
      'name': '50. Yıl Parkı',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Ankara\'nın en yüksek tepelerinden birinde, tüm şehri ayaklarınızın altına seren panoramik manzaralı park.',
      'rating': 4.7,
      'location': 'Cebeci',
      'comments': [{'user': 'Fotoğrafçı', 'text': 'Ankara manzarası en iyi buradan izlenir.', 'rating': 5.0}],
    },
    {
      'id': 513,
      'name': 'Kurtuluş Parkı',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Şehrin merkezinde, metro durağının hemen yanında, koşu parkuru ve buz pateni pisti olan ağaçlıklı park.',
      'rating': 4.4,
      'location': 'Kurtuluş',
      'comments': [{'user': 'Sporcu', 'text': 'Koşu parkuru çok kullanışlı.', 'rating': 4.0}],
    },
    {
      'id': 514,
      'name': 'Portakal Çiçeği Parkı',
      'category': '🏞️ Doğa & Parklar',
      'description': 'Vadi içinde saklı kalmış, sessiz ve huzurlu bir yürüyüş rotası.',
      'rating': 4.6,
      'location': 'Çankaya',
      'comments': [{'user': 'Mahalleli', 'text': 'Şehrin gürültüsünden kaçmak için birebir.', 'rating': 5.0}],
    },
    {
      'id': 17,
      'name': 'IF Performance Hall',
      'category': '🎉 Eğlence Yerleri',
      'description': 'Canlı müzik ve konserlerin adresi.',
      'rating': 4.5,
      'location': 'Tunalı',
      'comments': [{'user': 'Rockçı', 'text': 'Ses sistemi çok iyi.', 'rating': 5.0}],
    },

  ];

  // --- ETKİNLİKLER (Aynen Korundu) ---
  static final List<Map<String, dynamic>> events = [
    {
      'id': 101,
      'name': 'Büyük Ankara Caz Festivali',
      'date': '28 Kasım',
      'time': '20:00',
      'location': 'CSO Ada Ankara',
      'category': '🎉 Eğlence Yerleri',
      'color': Colors.purple.shade400,
    },
    {
      'id': 102,
      'name': 'Geleneksel Sokak Lezzetleri',
      'date': '01 Aralık',
      'time': '12:00 - 18:00',
      'location': 'Bahçelievler 7. Cadde',
      'category': '🍴 Yeme & İçme Yerleri',
      'color': Colors.orange.shade400,
    },
    {
      'id': 103,
      'name': 'Modern Sanat Sergisi Açılışı',
      'date': '05 Aralık',
      'time': '18:30',
      'location': 'CerModern',
      'category': '🎭 Sanat & Kültür Yerleri',
      'color': Colors.pink.shade300,
    },
    {
      'id': 104,
      'name': 'Yapay Zeka ve Gelecek Paneli',
      'date': '10 Aralık',
      'time': '14:00',
      'location': 'ODTÜ Teknokent',
      'category': '🏛️ Tarihi Yerler',
      'color': Colors.blue.shade600,
    },
    {
      'id': 105,
      'name': 'Eymir Gölü Doğa Yürüyüşü',
      'date': '12 Aralık',
      'time': '08:00',
      'location': 'Eymir Gölü',
      'category': '🏞️ Doğa & Parklar',
      'color': Colors.green.shade500,
    },
    {
      'id': 106,
      'name': 'Antika Pazarı ve Müzayede',
      'date': '15 Aralık',
      'time': '10:00',
      'location': 'Ayrancı Pazarı',
      'category': '🛍️ Alışveriş',
      'color': Colors.brown.shade400,
    },
    {
      'id': 107,
      'name': 'Derbi Heyecanı Dev Ekranda',
      'date': '18 Aralık',
      'time': '19:00',
      'location': 'Kızılay Meydanı',
      'category': '⚽ Spor Yerleri',
      'color': Colors.redAccent.shade700,
    },
    {
      'id': 108,
      'name': 'Gece Sineması: Nostalji',
      'date': '22 Aralık',
      'time': '21:00',
      'location': 'Kuğulu Park',
      'category': '🎭 Sanat & Kültür Yerleri',
      'color': Colors.indigo.shade400,
    },
  ];

  static List<Map<String, dynamic>> filterAndSortItems(
      String category,
      double minRating,
      double maxRating,
      SortingType sortingType,
      String subCategoryFilter,
      String subSubCategoryFilter,
      ) {
    List<Map<String, dynamic>> filteredList = items
        .where((item) => item['category'] == category)
        .where((item) => (item['rating'] as double) >= minRating && (item['rating'] as double) <= maxRating)
        .toList();

    final bool hasSubCategories = category == '🍴 Yeme & İçme Yerleri' || category == '🎭 Sanat & Kültür Yerleri'|| category == '🛍️ Alışveriş';

    if (hasSubCategories && subCategoryFilter != 'Hepsi') {
      filteredList = filteredList
          .where((item) => item['sub_category'] == subCategoryFilter)
          .toList();
    }

    if (subCategoryFilter == 'Dünya Mutfağı' && subSubCategoryFilter != 'Hepsi') {
      filteredList = filteredList
          .where((item) => item['sub_sub_category'] == subSubCategoryFilter)
          .toList();
    }

    if (sortingType == SortingType.ratingHighToLow) {
      filteredList.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    } else if (sortingType == SortingType.ratingLowToHigh) {
      filteredList.sort((a, b) => (a['rating'] as double).compareTo(b['rating'] as double));
    }
    return filteredList;
  }
}