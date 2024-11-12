import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/user_mdel.dart';


class CrearGrupoEstudio extends StatefulWidget {
  final UserModel user;
  const CrearGrupoEstudio({required this.user,super.key});
  

  @override
  _CrearGrupoEstudioState createState() => _CrearGrupoEstudioState();

}

class _CrearGrupoEstudioState extends State<CrearGrupoEstudio> {
  late TextEditingController nameUser;
  late TextEditingController isTutor;
  late TextEditingController cupos;
  late TextEditingController facultad;
  late TextEditingController escuela;
  late TextEditingController materia;
  late TextEditingController nombreGrupo;
  late TextEditingController tema;
  late TextEditingController descripcion;
  @override
  void initState() {
    super.initState();
    nameUser = TextEditingController(text: widget.user.name);
    isTutor =
        TextEditingController(text: widget.user.title);
  }



  // ignore: unused_element
  Future<void> _crearGrupo() async {
    try {
      // Guardar datos adicionales en Firestore
      await FirebaseFirestore.instance
          .collection('gruposEstudio').doc()
          .set({
        'propietario': nameUser,
        'nombreGrupo': nombreGrupo,
        'facultad': facultad,
        'escuela': escuela,
        'materia': materia,
        'idGrupo': 001, //AQUI ME GUSTARIA QUE EL ID SE GENERARA SOLO
        'cupos' : cupos,   //
        'tema' : tema,
        'tutor': false,
        'descripcionGrupo': descripcion,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro de grupo exitoso. Por favor, verifica tu correo.'),
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
    return Scaffold(
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Creación de grupos',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  Scaffold.of(context).openDrawer();
                }
              },
              child: Container(
                width: 10, 
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20), 
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_ios, 
                  size: 16,
                  color: Colors.white.withOpacity(0.8), 
                ),
              ),
            ),
          ),
        ],
      ), 
    );
  }

  























}