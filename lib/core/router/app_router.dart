import 'package:bharatnxt_app/presentation/chat_screen/chat_screen.dart';
import 'package:bharatnxt_app/presentation/history_screen/history_screen.dart';
import 'package:bharatnxt_app/presentation/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String chat = '/chat';
  static const String history = '/history';

  static final _rootKey = GlobalKey<NavigatorState>();
  static final _shellKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: home,
    routes: [
      ShellRoute(
        navigatorKey: _shellKey,
        builder:
            (context, state, child) => _ScaffoldWithBottomNav(child: child),
        routes: [
          GoRoute(
            path: home,
            parentNavigatorKey: _shellKey,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: chat,
            parentNavigatorKey: _shellKey,
            builder: (_, state) {
              final extra = state.extra as Map<String, String>?;
              return ChatScreen(prefilledMessage: extra?['message']);
            },
          ),
          GoRoute(
            path: history,
            parentNavigatorKey: _shellKey,
            builder: (_, __) => const HistoryScreen(),
          ),
        ],
      ),
    ],
  );
}

class _ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;
  const _ScaffoldWithBottomNav({required this.child});

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith(AppRouter.chat)) return 1;
    if (loc.startsWith(AppRouter.history)) return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.home);
      case 1:
        context.go(AppRouter.chat);
      case 2:
        context.go(AppRouter.history);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex(context),
          onTap: (i) => _onTap(context, i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline_rounded),
              activeIcon: Icon(Icons.lightbulb_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              activeIcon: Icon(Icons.chat_bubble_rounded),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              activeIcon: Icon(Icons.history_rounded),
              label: 'History',
            ),
          ],
        ),
      ),
    );
  }
}
