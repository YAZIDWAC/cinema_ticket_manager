import 'package:flutter/material.dart';

import 'movies_page.dart';
import 'salles_page.dart';
import 'sessions_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administration')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Gestion des films'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MoviesPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Gestion des salles'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SallesPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Gestion des séances'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SessionsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
