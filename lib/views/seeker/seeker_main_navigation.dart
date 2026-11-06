import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../state/app_state.dart';
import 'seeker_home_screen.dart';
import 'seeker_applications_screen.dart';
import 'seeker_favorites_screen.dart';
import 'seeker_profile_screen.dart';
import '../common/chat_list_screen.dart';

class SeekerMainNavigation extends StatefulWidget {
  final AppState appState;

  const SeekerMainNavigation({super.key, required this.appState});

  @override
  State<SeekerMainNavigation> createState() => _SeekerMainNavigationState();
}

class _SeekerMainNavigationState extends State<SeekerMainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      SeekerHomeScreen(appState: widget.appState),
      SeekerApplicationsScreen(appState: widget.appState),
      SeekerFavoritesScreen(appState: widget.appState),
      ChatListScreen(appState: widget.appState),
      SeekerProfileScreen(appState: widget.appState),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              activeIcon: Icon(Icons.search_rounded, color: AppColors.primary),
              label: 'İşler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment_rounded, color: AppColors.primary),
              label: 'Başvurularım',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              activeIcon: Icon(Icons.favorite_rounded, color: AppColors.primary),
              label: 'Favoriler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              activeIcon: Icon(Icons.chat_bubble_rounded, color: AppColors.primary),
              label: 'Mesajlar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded, color: AppColors.primary),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
