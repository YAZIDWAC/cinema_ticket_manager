import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';

import 'movies_page.dart';
import 'salles_page.dart';
import 'sessions_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  static const Color grenat = Color(0xFF8B1E3F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administration"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _AdminImageCard(
              title: "Films",
              imagePath: "assets/images/film.jpg",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MoviesPage()),
                );
              },
            ),
            _AdminImageCard(
              title: "Salles",
              imagePath: "assets/images/cineBackground.jpg",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SallesPage()),
                );
              },
            ),
            _AdminImageCard(
              title: "Séances",
              imagePath: "assets/images/movietime.jpg",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SessionsPage(isAdmin: true),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      /// 🔴 BOUTON LOGOUT EN BAS À GAUCHE
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "logoutBtn",
        backgroundColor: Colors.red,
        icon: const Icon(Icons.logout),
        label: const Text("Logout"),
        onPressed: () {
          context.read<AuthBloc>().add(LogoutRequested());
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startFloat, // 👈 BAS GAUCHE
    );
  }
}

class _AdminImageCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const _AdminImageCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            /// 🖼 IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// 📝 TITRE
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
