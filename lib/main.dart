import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/session_repository.dart';
import 'presentation/blocs/session/session_bloc.dart';

import 'firebase_options.dart';

// AUTH
import 'presentation/blocs/auth/auth_bloc.dart';

// MOVIES
import 'presentation/blocs/movie/movie_bloc.dart';
import 'data/repositories/movie_repository.dart';

// SALLES
import 'presentation/blocs/salle/salle_bloc.dart';
import 'data/repositories/salle_repository.dart';

// SESSIONS ✅
import 'presentation/blocs/session/session_bloc.dart';
import 'data/repositories/session_repository.dart';

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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthBloc()),
    BlocProvider(create: (_) => MovieBloc(MovieRepository())),
    BlocProvider(create: (_) => SalleBloc(SalleRepository())),
    BlocProvider(create: (_) => SessionBloc(SessionRepository())),
  ],
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ),
);

  }
}
