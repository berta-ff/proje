import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // --- DURUM DEĞİŞKENLERİ ---
  Set<int> _selectedRatings = {};
  String? _sortOption;
  final TextEditingController _commentController = TextEditingController();
  double _newRating = 5.0;
  bool _isCommentAreaVisible = false;
  late List<Map<String, dynamic>> _localComments;

  @override
  void initState() {
    super.initState();
    _initializeComments();
  }

  void _initializeComments() {
    final rawComments = widget.item['comments'] as List<dynamic>? ?? [];
    _localComments = rawComments.map((c) {
      final Map<String, dynamic> commentMap = Map.from(c as Map<String, dynamic>);
      if (!commentMap.containsKey('likes')) commentMap['likes'] = 0;
      if (!commentMap.containsKey('dislikes')) commentMap['dislikes'] = 0;
      if (!commentMap.containsKey('userStatus')) commentMap['userStatus'] = null;
      return commentMap;
    }).toList();
  }

  // --- FİLTRELEME VE SIRALAMA ---
  List<Map<String, dynamic>> get _filteredComments {
    List<Map<String, dynamic>> list = List.from(_localComments);

    if (_selectedRatings.isNotEmpty) {
      list = list.where((comment) {
        final rating = (comment['rating'] as num).round();
        return _selectedRatings.contains(rating);
      }).toList();
    }

    if (_sortOption == 'En İyi Değerlendirmeler') {
      list.sort((a, b) => (b['likes'] as int).compareTo(a['likes'] as int));
    } else if (_sortOption == 'Yeniden Eskiye') {
      list = list.reversed.toList();
    }
    return list;
  }

  // --- BEĞENİ / BEĞENMEME ---
  void _handleReaction(int index, String reactionType) {
    setState(() {
      final comment = _filteredComments[index];
      String? currentStatus = comment['userStatus'];

      if (currentStatus == reactionType) {
        comment['userStatus'] = null;
        if (reactionType == 'like') {
          comment['likes'] = (comment['likes'] as int) - 1;
        } else {
          comment['dislikes'] = (comment['dislikes'] as int) - 1;
        }
      } else {
        if (currentStatus == 'like') {
          comment['likes'] = (comment['likes'] as int) - 1;
        } else if (currentStatus == 'dislike') {
          comment['dislikes'] = (comment['dislikes'] as int) - 1;
        }

        comment['userStatus'] = reactionType;
        if (reactionType == 'like') {
          comment['likes'] = (comment['likes'] as int) + 1;
        } else {
          comment['dislikes'] = (comment['dislikes'] as int) + 1;
        }
      }
    });
  }

  // --- YORUM EKLEME ---
  void _addComment() {
    final User? currentUser = Provider.of<UserNotifier>(context, listen: false).currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yorum yapabilmek için giriş yapmalısınız.')));
      return;
    }
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen bir yorum yazın.')));
      return;
    }

    final newComment = {
      'user': currentUser.kullaniciAdi,
      'text': _commentController.text.trim(),
      'rating': _newRating,
      'likes': 0,
      'dislikes': 0,
      'userStatus': null,
    };

    setState(() {
      _localComments.add(newComment);
      widget.item['comments'] = _localComments; // DataModel'i güncelle
      _commentController.clear();
      _isCommentAreaVisible = false;
      _newRating = 5.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yorumunuz eklendi!')));
  }

  // --- 🔥 GÜNCELLENMİŞ BÖLÜM: MAĞAZALAR (Kategorili Map okuyor) ---
  Widget _buildBrandsSection(Map<String, List<String>>? brandCategories) {
    if (brandCategories == null || brandCategories.isEmpty) return const SizedBox.shrink();

    final categoryTitles = brandCategories.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mağazalar & Markalar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),

        ...categoryTitles.map((title) {
          final brands = brandCategories[title]!;

          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kategori Başlığı (Örn: Giyim & Moda)
                Text('>> $title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                const SizedBox(height: 8),

                // Marka Etiketleri (Chips)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: brands.map((brand) => Chip(
                    label: Text(brand, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  )).toList(),
                ),
              ],
            ),
          );
        }).toList(),

        const Divider(height: 30),
      ],
    );
  }

  Widget _buildMenuSection(List<Map<String, dynamic>>? menu) {
    if (menu == null || menu.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Popüler Menüler', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...menu.map((m) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(m['name']!),
              Text('${m['price']} ₺', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        )),
        const Divider(height: 30),
      ],
    );
  }

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.grey, size: 16);
        }
      }),
    );
  }

  Widget _buildSortChip(String label) {
    final bool isSelected = _sortOption == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _sortOption = selected ? label : null;
          });
        },
        selectedColor: Colors.black87,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buildStarFilterChip(int starCount) {
    final bool isSelected = _selectedRatings.contains(starCount);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$starCount'),
            const SizedBox(width: 4),
            Icon(Icons.star, size: 16, color: isSelected ? Colors.white : Colors.amber),
          ],
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedRatings.add(starCount);
            } else {
              _selectedRatings.remove(starCount);
            }
          });
        },
        selectedColor: Colors.black87,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
        checkmarkColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFoodCategory = widget.item['category'] == '🍴 Yeme & İçme Yerleri';
    final isShopping = widget.item['category'] == '🛍️ Alışveriş';
    final accentColor = Theme.of(context).colorScheme.secondary;

    // 🔥 GÜNCEL VERİ OKUMA: brand_categories map'ini okur
    Map<String, List<String>>? brandsCategories;
    if (widget.item['brand_categories'] != null) {
      brandsCategories = (widget.item['brand_categories'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, List<String>.from(value as List<dynamic>)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['name']!),
        backgroundColor: accentColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görsel Alanı
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/images/detail_placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                  child: Icon(
                      isFoodCategory ? Icons.restaurant : (isShopping ? Icons.shopping_bag : Icons.camera_alt),
                      size: 50,
                      color: Colors.grey[600]
                  )
              ),
            ),
            const SizedBox(height: 16),

            // Başlık ve Puan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(widget.item['name']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                  child: Text('${widget.item['rating']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.item['description']!, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const Divider(height: 30),

            // Menü (Yemekse) veya Mağazalar (AVM ise)
            if (isFoodCategory) _buildMenuSection(widget.item['menu'] as List<Map<String, dynamic>>?),
            _buildBrandsSection(brandsCategories), // 🔥 YENİ KATEGORİLİ YAPIDAN OKUYOR

            // Yorum Başlığı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Değerlendirmeler', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () => setState(() => _isCommentAreaVisible = !_isCommentAreaVisible),
                  icon: Icon(_isCommentAreaVisible ? Icons.close : Icons.edit, color: accentColor),
                  label: Text(_isCommentAreaVisible ? 'Vazgeç' : 'Yorum Yaz', style: TextStyle(color: accentColor)),
                ),
              ],
            ),

            // Yorum Ekleme Formu
            if (_isCommentAreaVisible)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Puanınız:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Slider(
                          value: _newRating, min: 1, max: 5, divisions: 4,
                          label: _newRating.toInt().toString(),
                          activeColor: Colors.amber,
                          onChanged: (val) => setState(() => _newRating = val),
                        ),
                        Text('${_newRating.toInt()} Yıldız', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                      ],
                    ),
                    TextField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Deneyimlerinizi paylaşın...',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(onPressed: _addComment, child: const Text('Yorumu Gönder')),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            // Filtreler
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip('En İyi Değerlendirmeler'),
                  _buildSortChip('Yeniden Eskiye'),
                  Container(height: 30, width: 1, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 8)),
                  for (int i = 5; i >= 1; i--) _buildStarFilterChip(i),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Yorum Listesi
            if (_filteredComments.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Center(child: Text('Bu kriterlere uygun değerlendirme yok.', style: TextStyle(color: Colors.grey))),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredComments.length,
                itemBuilder: (context, index) {
                  final comment = _filteredComments[index];
                  final userStatus = comment['userStatus'];

                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Text(comment['user']![0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(comment['user']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            _buildRatingStars(comment['rating'] as double),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(comment['text']!, style: const TextStyle(color: Colors.black87, fontSize: 15)),
                            const SizedBox(height: 10),
                            // Like / Dislike
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => _handleReaction(index, 'like'),
                                  child: Row(
                                    children: [
                                      Icon(userStatus == 'like' ? Icons.thumb_up : Icons.thumb_up_off_alt, size: 20, color: userStatus == 'like' ? Colors.blue : Colors.grey),
                                      const SizedBox(width: 4),
                                      Text('${comment['likes']}', style: TextStyle(color: userStatus == 'like' ? Colors.blue : Colors.grey, fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: () => _handleReaction(index, 'dislike'),
                                  child: Row(
                                    children: [
                                      Icon(userStatus == 'dislike' ? Icons.thumb_down : Icons.thumb_down_off_alt, size: 20, color: userStatus == 'dislike' ? Colors.red : Colors.grey),
                                      const SizedBox(width: 4),
                                      Text('${comment['dislikes']}', style: TextStyle(color: userStatus == 'dislike' ? Colors.red : Colors.grey, fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}