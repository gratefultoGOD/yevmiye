import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/constants/app_theme.dart';
import 'state/app_state.dart';
import 'views/auth/login_screen.dart';
import 'views/seeker/seeker_main_navigation.dart';
import 'views/employer/employer_main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  runApp(const YevmiyeApp());
}

class YevmiyeApp extends StatefulWidget {
  const YevmiyeApp({super.key});

  @override
  State<YevmiyeApp> createState() => _YevmiyeAppState();
}

class _YevmiyeAppState extends State<YevmiyeApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Yevmiye - Günlük İş & İşçi Bulma',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: _buildRootScreen(),
        );
      },
    );
  }

  Widget _buildRootScreen() {
    if (!_appState.isAuthenticated || _appState.currentUser == null) {
      return LoginScreen(appState: _appState);
    }

    if (_appState.isEmployer) {
      return EmployerMainNavigation(appState: _appState);
    }

    return SeekerMainNavigation(appState: _appState);
  }
}
