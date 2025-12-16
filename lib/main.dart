import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

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

// RESERVATIONS ✅
import 'presentation/blocs/reservation/reservation_bloc.dart';
import 'data/repositories/reservation_repository.dart';

// UI
import 'presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AUTH
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
        ),

        // MOVIES
        BlocProvider<MovieBloc>(
          create: (_) =>
              MovieBloc(MovieRepository())..add(LoadMovies()),
        ),

        // SALLES
        BlocProvider<SalleBloc>(
          create: (_) =>
              SalleBloc(SalleRepository())..add(LoadSalles()),
        ),

        // SESSIONS
        BlocProvider<SessionBloc>(
  create: (_) =>
      SessionBloc(SessionRepository())..add(LoadSessions()),
),

        // RESERVATIONS ✅
        BlocProvider<ReservationBloc>(
          create: (_) =>
              ReservationBloc(ReservationRepository()),
        ),
      ],
      child: MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    primaryColor: Colors.deepPurple,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
  ),
  home: LoginPage(),
),

    );
  }
}
