import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _idUsuarioController = TextEditingController();
  final TextEditingController _nombrePublicoController = TextEditingController();

  String carreraSeleccionada = 'Ingeniería de Sistemas'; // Opción por defecto
  final List<String> carreras = [
    'Ingeniería de Sistemas',
    'Ingeniería Civil',
    'Medicina',
    'Derecho',
    'Ingeniería Eléctronica'
  ];

  Future<void> _register() async {
    try {
      // Crear usuario con email y contraseña
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Enviar correo de verificación
      await userCredential.user?.sendEmailVerification();

      // Guardar datos adicionales en Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user?.uid)
          .set({
        'usuario': _idUsuarioController.text.trim(),
        'name': _nombrePublicoController.text.trim(),
        'carrera': carreraSeleccionada,
        'correo': _emailController.text.trim(),
        'Titulo': 'Estudiante',
        'imageUrl': 'https://via.placeholder.com/150' // URL de imagen por defecto
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro exitoso. Por favor, verifica tu correo.'),
        ),
      );

      // Regresar a la pantalla de inicio de sesión
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener dimensiones de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(153, 84, 230, 59),
      appBar: AppBar(
        title: const Text('Volver al login'),
        backgroundColor: const Color.fromARGB(153, 84, 230, 59),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _idUsuarioController,
              decoration: const InputDecoration(
                labelText: 'ID de Usuario (único)',
                labelStyle: TextStyle(color: Color.fromARGB(196, 225, 225, 225)),
                fillColor: Color.fromRGBO(26, 186, 66, 0.498),
                filled: true,
              ),
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _nombrePublicoController,
              decoration: const InputDecoration(
                labelText: 'Nombre Público',
                labelStyle: TextStyle(color: Color.fromARGB(196, 225, 225, 225)),
                fillColor: Color.fromRGBO(26, 186, 66, 0.498),
                filled: true,
              ),
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                labelStyle: TextStyle(color: Color.fromARGB(196, 225, 225, 225)),
                fillColor: Color.fromRGBO(26, 186, 66, 0.498),
                filled: true,
              ),
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: Color.fromARGB(196, 225, 225, 225)),
                fillColor: Color.fromRGBO(26, 186, 66, 0.498),
                filled: true,
              ),
              style: const TextStyle(fontSize: 13, color: Colors.white),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: carreraSeleccionada,
              onChanged: (String? newValue) {
                setState(() {
                  carreraSeleccionada = newValue!;
                });
              },
              items: carreras.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              width: screenWidth * 0.8,
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: const EdgeInsets.all(10),
                ),
                child: const Text(
                  'Registro',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
