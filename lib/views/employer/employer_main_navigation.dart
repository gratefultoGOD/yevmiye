import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../state/app_state.dart';
import 'employer_home_screen.dart';
import 'employer_applicants_screen.dart';
import 'employer_profile_screen.dart';
import '../common/chat_list_screen.dart';

class EmployerMainNavigation extends StatefulWidget {
  final AppState appState;

  const EmployerMainNavigation({super.key, required this.appState});

  @override
  State<EmployerMainNavigation> createState() => _EmployerMainNavigationState();
}

class _EmployerMainNavigationState extends State<EmployerMainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      EmployerHomeScreen(appState: widget.appState),
      EmployerApplicantsScreen(appState: widget.appState),
      ChatListScreen(appState: widget.appState),
      EmployerProfileScreen(appState: widget.appState),
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
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded, color: AppColors.primary),
              label: 'İlanlarım',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded),
              activeIcon: Icon(Icons.people_rounded, color: AppColors.primary),
              label: 'Başvurular',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              activeIcon: Icon(Icons.chat_bubble_rounded, color: AppColors.primary),
              label: 'Mesajlar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront_rounded, color: AppColors.primary),
              label: 'İşletmem',
            ),
          ],
        ),
      ),
    );
  }
}
