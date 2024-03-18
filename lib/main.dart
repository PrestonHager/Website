import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';

import 'package:nmsu_gsdc_website/login.dart';
import 'package:nmsu_gsdc_website/signup.dart';
import 'package:nmsu_gsdc_website/profile.dart';
import 'package:nmsu_gsdc_website/firebase_options.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NMSU GSDC Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/signup');
            },
          ),
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/login');
            },
          ),
        ],
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: const [
          Card(
            child: Column(
              children: [
                Text('Project 1'),
                Text('Description 1'),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                Text('Project 2'),
                Text('Description 2'),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                Text('Project 3'),
                Text('Description 3'),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                Text('Project 4'),
                Text('Description 4'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
