import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Antology',
      debugShowCheckedModeBanner: false,
      theme: AntologyTheme.lightTheme,
      home: HomeScreen(storage: storage),
      routes: {
        '/home': (context) => HomeScreen(storage: storage),
        '/add-colony': (context) => AddColonyScreen(storage: storage),
      },
    );
  }
}