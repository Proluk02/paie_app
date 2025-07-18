import 'package:flutter/material.dart';
import 'vues/accueil.dart';
import 'vues/paiements.dart';
import 'vues/statistiques.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Frais Étudiants',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0.5,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State createState() => _MainPageState();
}

class _MainPageState extends State {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AccueilPage(),
    PaiementsPage(matricule: ''),
    StatistiquesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSelectDrawerItem(int index) {
    Navigator.pop(context);
    _onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion Frais Étudiants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Paramètres',
            onPressed: () {
              // TODO: Ouvrir page paramètres
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menu principal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_outline,
                color: Colors.blueAccent,
              ),
              title: const Text('Étudiants'),
              onTap: () => _onSelectDrawerItem(0),
            ),
            ListTile(
              leading: const Icon(Icons.payment_outlined, color: Colors.teal),
              title: const Text('Paiements'),
              onTap: () => _onSelectDrawerItem(1),
            ),
            ListTile(
              leading: const Icon(
                Icons.bar_chart_outlined,
                color: Colors.deepPurple,
              ),
              title: const Text('Statistiques'),
              onTap: () => _onSelectDrawerItem(2),
            ),
            const Divider(),
            ExpansionTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text('Paramètres'),
              children: [
                ListTile(
                  title: const Text('Profil'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Page Profil
                  },
                ),
                ListTile(
                  title: const Text('Déconnexion'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Déconnexion
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: Colors.white,
        elevation: 8,
        indicatorColor: Colors.blueAccent.shade100,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Étudiants'),
          NavigationDestination(icon: Icon(Icons.payment), label: 'Paiements'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }
}
