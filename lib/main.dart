import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'presentation/pages/splash_page.dart';

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

/// 🎨 GRENAT UNIQUE
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
          useMaterial3: false,
          primaryColor: kGrenat,
          scaffoldBackgroundColor: const Color(0xFFFDF5F5),

          appBarTheme: const AppBarTheme(
            backgroundColor: kGrenat,
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kGrenat,
              foregroundColor: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
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
        home: const SplashPage(),
      ),
    );
  }
}
