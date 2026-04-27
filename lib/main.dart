import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';
import 'screens/colony_detail_screen.dart';
import 'screens/add_colony_screen.dart';
import 'antology_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storage = StorageService();
  await storage.init();
  
  runApp(AntologyApp(storage: storage));
}

class AntologyApp extends StatelessWidget {
  final StorageService storage;
  
  const AntologyApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(storage: storage),
        ),
        GoRoute(
          path: '/colony/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ColonyDetailScreen(colonyId: id, storage: storage);
          },
        ),
        GoRoute(
          path: '/add-colony',
          builder: (context, state) => AddColonyScreen(storage: storage),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Antology',
      debugShowCheckedModeBanner: true,
      theme: AntologyTheme.lightTheme,
      routerConfig: router,
    );
  }
}