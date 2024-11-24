import 'package:flutter/material.dart';
import 'package:lfru_app/models/grupos_model.dart';

class MostrarGrupos extends StatelessWidget {
  final List<GruposModel> grupos;

  const MostrarGrupos({super.key, required this.grupos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mostrar Grupos'),
      ),
      resizeToAvoidBottomInset: true, // Asegúrate de que la pantalla se ajuste al teclado
      body: grupos.isEmpty
          ? const Center(child: Text('No se encontraron grupos.'))
          : SingleChildScrollView( // Aquí usamos SingleChildScrollView para que todo sea desplazable
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: grupos.map((grupo) {
                    bool esGrupoPorTutor = grupo.tutor;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: esGrupoPorTutor ? Colors.blueAccent : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nombre del grupo
                            Text(
                              'Nombre del Grupo: ${grupo.nombreGrupo}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: esGrupoPorTutor ? Colors.blueAccent : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Descripción del grupo
                            Text(
                              'Descripción: ${grupo.descripcionGrupo}',
                              style: TextStyle(
                                fontStyle: esGrupoPorTutor ? FontStyle.italic : FontStyle.normal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Cupos disponibles
                            Text('Cupos disponibles: ${grupo.cupos}'),

                            // Si es un grupo creado por un tutor, mostrar un ícono especial
                            if (esGrupoPorTutor)
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.blueAccent),
                                    SizedBox(width: 4),
                                    Text(
                                      'Grupo creado por tutor',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
