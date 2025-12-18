import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.movie_creation_rounded,
                size: 70,
                color: Color(0xFFE53935),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "My Cinema",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB71C1C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Votre cinéma, vos places, en un clic",
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
