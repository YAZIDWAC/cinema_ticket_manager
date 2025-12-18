import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

// PAGES
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/AdminHomePage.dart';

// AUTH
import 'presentation/blocs/auth/auth_bloc.dart';

// MOVIES
import 'presentation/blocs/movie/movie_bloc.dart';
import 'presentation/blocs/movie/movie_event.dart';
import 'data/repositories/movie_repository.dart';

// SALLES
import 'presentation/blocs/salle/salle_bloc.dart';
import 'presentation/blocs/salle/salle_event.dart';
import 'data/repositories/salle_repository.dart';

// SESSIONS
import 'presentation/blocs/session/session_bloc.dart';
import 'presentation/blocs/session/session_event.dart';
import 'data/repositories/session_repository.dart';

// RESERVATIONS
import 'presentation/blocs/reservation/reservation_bloc.dart';
import 'data/repositories/reservation_repository.dart';

//FireBase
import 'package:cloud_firestore/cloud_firestore.dart';

/// 🎨 GRENAT
const Color kGrenat = Color(0xFF8B1E3F);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<MovieBloc>(
          create: (_) =>
              MovieBloc(MovieRepository())..add(LoadMovies()),
        ),
        BlocProvider<SalleBloc>(
          create: (_) =>
              SalleBloc(SalleRepository())..add(LoadSalles()),
        ),
        BlocProvider<SessionBloc>(
          create: (_) =>
              SessionBloc(SessionRepository())..add(LoadSessions()),
        ),
        BlocProvider<ReservationBloc>(
          create: (_) =>
              ReservationBloc(ReservationRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kGrenat,
          scaffoldBackgroundColor: const Color(0xFFFDF5F5),
          appBarTheme: const AppBarTheme(
            backgroundColor: kGrenat,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kGrenat,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        /// 🚀 SPLASH → AUTH (LOGIQUE UNIQUE)
        home: const AppBootstrap(),
      ),
    );
  }
}

/// 🔐 BOOTSTRAP DE L'APP (SPLASH + AUTH + ROLE)
class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  Future<String> _getUserRole(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    return doc.data()?['role'] ?? 'client';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3)), // SPLASH
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SplashPage();
        }

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // ❌ PAS CONNECTÉ
            if (!authSnapshot.hasData) {
              return const LoginPage();
            }

            // ✅ CONNECTÉ → LIRE LE ROLE
            final user = authSnapshot.data!;

            return FutureBuilder<String>(
              future: _getUserRole(user.uid),
              builder: (context, roleSnapshot) {
                if (!roleSnapshot.hasData) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                final role = roleSnapshot.data!;

                /// 👑 ADMIN
                if (role == 'admin') {
                  return const AdminHomePage();
                }

                /// 👤 CLIENT
                return const HomePage();
              },
            );
          },
        );
      },
    );
  }
}
