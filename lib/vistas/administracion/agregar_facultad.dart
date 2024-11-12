import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/carrera.dart';
import 'package:lfru_app/models/facultad.dart';

class AgregarFacultad extends StatefulWidget {
  const AgregarFacultad({super.key});

  @override
  _AgregarFacultadState createState() => _AgregarFacultadState();
}

class _AgregarFacultadState extends State<AgregarFacultad> {
  final TextEditingController _nombreController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Carrera> _carrerasDisponibles = [];
  final List<Carrera> _carrerasSeleccionadas = [];

  @override
  
  void initState() {
    super.initState();
    _cargarCarrerasDisponibles();
  }

  // CARGAR LAS CARRERAS SELECCIONADAS EN FIRESTORE

  Future<void> _cargarCarrerasDisponibles() async{
    final snapshot = await _firestore.collection('carreras').get();
    setState(() {
      _carrerasDisponibles = snapshot.docs.map((doc) => Carrera.fromMap(doc.data())).toList();
    });
  }

  // Lógica para guardar la carrera en Firestore
  Future<void> _agregarFacultad() async {
    String nombre = _nombreController.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa el nombre de la facultad')),
      );
      return;
    }

    // CREAR UNA NUEVA FACULTAD CON LAS CARRERAS SELECCIONADAS
    Facultad nuevaFacultad = Facultad(
      id: '', // Dejamos el id vacío para que Firestore lo genere automáticamente
      nombreFacultad: nombre,
      carreras: _carrerasSeleccionadas,
    );

    try {
      final docRef = await _firestore.collection('facultad').add(nuevaFacultad.toMap());
      nuevaFacultad = nuevaFacultad.copyWith(id: docRef.id);
      await docRef.update({'id': nuevaFacultad.id});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Carrera agregada exitosamente')),
      );

      _nombreController.clear();
      setState(() {
        _carrerasSeleccionadas.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar carrera: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Facultad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nombre de la Facultad',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(hintText: 'Ejemplo: Facultad de fisicomecanicas'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Carreras',
              style: TextStyle(fontSize: 18),
            ),
            DropdownButtonFormField<Carrera>(
              isExpanded: true,
              hint: const Text('Selecciona una Carrera'),
              items: _carrerasDisponibles.map((carrera) {
                return DropdownMenuItem(
                  value: carrera,
                  child: Text(carrera.nombreCarrera),
                );
              }).toList(),
              onChanged: (carreraSeleccionada) {
                setState(() {
                  if (!_carrerasSeleccionadas.contains(carreraSeleccionada)) {
                    _carrerasSeleccionadas.add(carreraSeleccionada!);
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              children: _carrerasSeleccionadas.map((carrera) {
                return Chip(
                  label: Text(carrera.nombreCarrera),
                  onDeleted: () {
                    setState(() {
                      _carrerasSeleccionadas.remove(carrera);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _agregarFacultad,
                child: const Text('Agregar Facultad'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
