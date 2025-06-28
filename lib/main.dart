import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'providers/characters_provider.dart';
import 'screens/characters_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configuración explícita para web
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBWS7swNB8nQg_CcwOcNfXxwBgcNpHq5ik",
        appId: "1:648071057535:web:7e469572f1a510d6c26f4a",
        messagingSenderId: "648071057535",
        projectId: "proyectoswapi2806",
        authDomain: "proyectoswapi2806.firebaseapp.com",
        storageBucket: "proyectoswapi2806.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CharactersProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Star Wars App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CharactersScreen(),
      ),
    );
  }
}