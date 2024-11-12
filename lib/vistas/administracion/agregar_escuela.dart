import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/escuela.dart';

class AgregarEscuela extends StatefulWidget {
  const AgregarEscuela({super.key});

  @override
  _AgregarEscuelaScreenState createState() => _AgregarEscuelaScreenState();
}

class _AgregarEscuelaScreenState extends State<AgregarEscuela> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _materiasController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lógica para guardar la escuela en Firestore
  Future<void> _agregarEscuela() async {
    // Obtenemos el nombre de la escuela y las materias del formulario
    String nombre = _nombreController.text.trim();
    List<String> materias = _materiasController.text
        .split(',') // Separar las materias por coma
        .map((materia) => materia.trim()) // Eliminar espacios extra
        .toList();

    // Verificamos que el nombre de la escuela no esté vacío
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa el nombre de la escuela')),
      );
      return;
    }

    // Crear el objeto escuela sin id, ya que se generará automáticamente
    Escuela nuevaEscuela = Escuela(
      id: '', // Dejamos el id vacío, Firestore generará uno automáticamente
      nombreEscuela: nombre,
      materias: materias,
    );

    try {
      // Usamos el método `add` para crear un nuevo documento con un ID auto-generado
      final docRef = await _firestore.collection('escuelas').add(nuevaEscuela.toMap());

      // Obtenemos el ID generado por Firestore y actualizamos el objeto escuela
      nuevaEscuela = nuevaEscuela.copyWith(id: docRef.id);

      // Actualizamos el documento con el ID generado
      await docRef.update({'id': nuevaEscuela.id});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escuela agregada exitosamente')),
      );

      // Limpiar los campos
      _nombreController.clear();
      _materiasController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar escuela: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Escuela'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nombre de la Escuela',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(hintText: 'Ejemplo: Escuela de Matematicas'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Materias (separadas por comas)',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _materiasController,
              decoration: const InputDecoration(hintText: 'Ejemplo: Calculo I, Algebra, Ecuaciones '),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _agregarEscuela,
                child: const Text('Agregar Escuela'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
