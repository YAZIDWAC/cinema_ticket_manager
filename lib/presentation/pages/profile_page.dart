import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: user == null
            ? const Center(
                child: Text("Utilisateur non connecté"),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person,
                    size: 80,
                  ),
                  const SizedBox(height: 16),

                  /// ✅ EMAIL UNIQUEMENT
                  Text(
                    "Email : ${user.email}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Divider(height: 32),

                  /// ✏️ Modifier profil (placeholder)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Modifier le profil"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Fonctionnalité à venir 👷"),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  /// 🚪 Déconnexion
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text("Se déconnecter"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                        (_) => false,
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
