import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_app/controller/services/auth_service.dart';
import 'package:tmdb_app/controller/services/search_service.dart';
import 'package:tmdb_app/firebase_options.dart';
import 'package:tmdb_app/model/custom_user.dart';
import 'package:tmdb_app/view/screens/splash_screen.dart';

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
    return MultiProvider(
      providers: [
        StreamProvider<CustomUser?>.value(
          value: AuthService().user,
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
        ChangeNotifierProvider(
          create: (context) => SearchService(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0x00e6a3e2)),
            // useMaterial3: true,
          ),
          home: const SplashScreen()),
    );
  }
}
