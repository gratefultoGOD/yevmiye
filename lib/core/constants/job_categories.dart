import 'package:flutter/material.dart';

class JobCategoryItem {
  final String id;
  final String title;
  final IconData icon;

  const JobCategoryItem({
    required this.id,
    required this.title,
    required this.icon,
  });
}

class AppCategories {
  static const List<JobCategoryItem> categories = [
    JobCategoryItem(id: 'all', title: 'Tümü', icon: Icons.grid_view_rounded),
    JobCategoryItem(id: 'garson', title: 'Garson', icon: Icons.room_service_rounded),
    JobCategoryItem(id: 'komi', title: 'Komi', icon: Icons.local_dining_rounded),
    JobCategoryItem(id: 'bulasikci', title: 'Bulaşıkçı', icon: Icons.soap_rounded),
    JobCategoryItem(id: 'mutfak', title: 'Mutfak personeli', icon: Icons.restaurant_rounded),
    JobCategoryItem(id: 'depo', title: 'Depo personeli', icon: Icons.inventory_2_rounded),
    JobCategoryItem(id: 'paketleme', title: 'Paketleme', icon: Icons.all_inbox_rounded),
    JobCategoryItem(id: 'tekstil', title: 'Tekstil işçisi', icon: Icons.checkroom_rounded),
    JobCategoryItem(id: 'temizlik', title: 'Temizlik personeli', icon: Icons.cleaning_services_rounded),
    JobCategoryItem(id: 'kurye', title: 'Kurye', icon: Icons.delivery_dining_rounded),
    JobCategoryItem(id: 'insaat', title: 'İnşaat işçisi', icon: Icons.construction_rounded),
    JobCategoryItem(id: 'etkinlik', title: 'Etkinlik personeli', icon: Icons.celebration_rounded),
    JobCategoryItem(id: 'diger', title: 'Diğer', icon: Icons.more_horiz_rounded),
  ];

  static const List<String> popularCities = [
    'Tüm Türkiye',
    'İstanbul',
    'Ankara',
    'İzmir',
    'Bursa',
    'Antalya',
    'Kocaeli',
    'Adana',
    'Konya',
    'Gaziantep',
    'Muğla'
  ];

  static const Map<String, List<String>> cityDistricts = {
    'İstanbul': ['Tümü', 'Kadıköy', 'Beşiktaş', 'Şişli', 'Üsküdar', 'Fatih', 'Bakırköy', 'Maltepe', 'Ataşehir'],
    'Ankara': ['Tümü', 'Çankaya', 'Keçiören', 'Yenimahalle', 'Mamak', 'Etimesgut'],
    'İzmir': ['Tümü', 'Konak', 'Karşıyaka', 'Bornova', 'Buca', 'Alsancak', 'Çeşme'],
    'Antalya': ['Tümü', 'Muratpaşa', 'Konyaaltı', 'Kepez', 'Alanya', 'Manavgat'],
  };
}
