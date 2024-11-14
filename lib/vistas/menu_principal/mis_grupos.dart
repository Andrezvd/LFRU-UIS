import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/grupos_model.dart';
import 'package:lfru_app/vistas/home/menu_lateral.dart';
import 'package:lfru_app/models/user_mdel.dart';

class MisGrupos extends StatefulWidget {
  const MisGrupos({super.key});

  @override
  _MisGruposState createState() => _MisGruposState();
}

class _MisGruposState extends State<MisGrupos> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? usuarioActual;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  // Método para cerrar sesión
  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  Future<UserModel?> getUserData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return null;
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .get();

    usuarioActual = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    setState(() {});
    return usuarioActual;
  }

  Future<List<GruposModel>> _getMyGroups() async {
    // Espera hasta que `usuarioActual` esté disponible
    if (usuarioActual == null) {
      await getUserData();
    }

    // Obtén los grupos desde el atributo `groups` de `usuarioActual`
    if (usuarioActual != null) {
      return usuarioActual!.groups;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Grupos'),
      ),
      body: FutureBuilder<List<GruposModel>>(
        // FutureBuilder con el tipo correcto
        future: _getMyGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes grupos creados.'));
          }

          // Listado de grupos creados por el usuario
          final grupos = snapshot.data!;
          return ListView.builder(
            itemCount: grupos.length,
            itemBuilder: (context, index) {
              final grupo = grupos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dueño: ${grupo.propietario.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cupos disponibles: ${grupo.cupos}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Descripción: ${grupo.descripcionGrupo}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      drawer: MenuLateral(logoutCallback: _logout),
    );
  }
}
