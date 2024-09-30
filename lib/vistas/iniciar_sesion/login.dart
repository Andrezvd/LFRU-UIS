import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lfru_app/vistas/iniciar_sesion/registro.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null && user.emailVerified) {
        Navigator.pushReplacementNamed(
            context, '/home'); // Ajusta la ruta según tu app
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Por favor verifica tu correo antes de iniciar sesión.'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    }
  }

  Future<void> _resetPassword() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Por favor, introduce tu correo electrónico.")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Se ha enviado un correo para restablecer tu contraseña.")),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(153, 84, 230, 59),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido de vuelta!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Inicie Sesión y busque sus grupos de estudio',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 225, 225, 225),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                labelStyle: TextStyle(
                  color: Color.fromARGB(196, 225, 225, 225),
                ),
                fillColor: Color.fromRGBO(26, 186, 66, 0.498),
                filled: true,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(
                  color: Color.fromARGB(196, 225, 225, 225),
                ),
                fillColor: Color.fromRGBO(26, 186, 66, 0.498),
                filled: true,
              ),
              obscureText: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
            // Alinear el botón a la izquierda y reducir el espacio
            Align(
              alignment: Alignment.centerLeft, // Alinea a la izquierda
              child: TextButton(
                onPressed: _resetPassword,
                child: const Text(
                  '¿Olvidó su contraseña?',
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: const EdgeInsets.all(10),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '¿No tienes una cuenta?',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 225, 225, 225),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistroPage()),
                    );
                  },
                  child: const Text(
                    'Regístrate',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.double,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
