import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lfru_app/firebase_options.dart';
import 'package:lfru_app/vistas/iniciar_sesion/login.dart';
import 'package:lfru_app/vistas/home/home.dart'; // Asegúrate de que esta ruta sea correcta

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase ha sido inicializado exitosamente.");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define las rutas en tu aplicación
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),  // Ajusta según tu pantalla de inicio
      },
    );
  }
}
