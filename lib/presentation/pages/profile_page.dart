import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_page.dart';

const Color kGrenat = Color(0xFF8B1E3F);
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<String> _getUserRole(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return doc.data()?['role'] ?? 'client';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // ✅ BACK FONCTIONNE
          },
        ),
      ),
      body: user == null
          ? const Center(child: Text("Utilisateur non connecté"))
          : FutureBuilder<String>(
              future: _getUserRole(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final role = snapshot.data ?? 'client';

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: kGrenat,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          user.email ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: role == 'admin'
                                ? kGrenat
                                : Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            role.toUpperCase(),
                            style: TextStyle(
                              color: role == 'admin'
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.logout),
                            label:
                                const Text("Se déconnecter"),
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        14),
                              ),
                            ),
                            onPressed: () async {
                              await FirebaseAuth.instance
                                  .signOut();

                              if (!context.mounted) return;

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const LoginPage(),
                                ),
                                (_) => false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
