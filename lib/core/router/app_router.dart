import 'package:go_router/go_router.dart';
import '../../features/accounts/presentation/home_screen.dart';
import '../../features/accounts/presentation/reorder_screen.dart';
import '../../features/accounts/presentation/search_screen.dart';
import '../../features/auth/presentation/biometric_unlock_screen.dart';
import '../../features/scanner/presentation/qr_scanner_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const BiometricUnlockScreen(
        child: HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/reorder',
      builder: (context, state) => const ReorderScreen(),
    ),
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const QrScannerScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
