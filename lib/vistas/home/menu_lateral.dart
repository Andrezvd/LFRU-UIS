import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lfru_app/models/userModel.dart';
import 'package:lfru_app/vistas/perfil_screens/perfil.dart';
import 'package:lfru_app/vistas/perfil_screens/editar_perfil.dart';

class MenuLateral extends StatefulWidget {
  final Function(BuildContext) logoutCallback;

  const MenuLateral({required this.logoutCallback, super.key});

  @override
  _MenuLateralState createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  Future<UserModel?> getUserData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return null; // No hay usuario autenticado
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('usuarios').doc(userId).get();

    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder<UserModel?>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Cargando
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error al cargar datos del usuario'));
              }

              final user = snapshot.data;

              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: constraints.maxHeight * 0.3, // Ajusta el tamaño del header
                    color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (user != null) {
                              // Navegar a la pantalla de perfil del usuario solo si 'user' no es nulo
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserProfileScreen(user: user)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Datos de usuario no disponibles')),
                              );
                            }
                          },
                          child: CircleAvatar(
                            radius: 40, // Ajusta el tamaño según sea necesario
                            backgroundImage: NetworkImage(user?.imageUrl ?? 'https://via.placeholder.com/150'), // Imagen del usuario
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user?.name ?? 'Nombre por defecto',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          user?.title ?? 'Título por defecto',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Inicio'),
                    onTap: () {
                      Navigator.pop(context); // Cierra el drawer
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Configuración'),
                    onTap: () {
                      // Acción de configuración
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Editar Perfil'),
                    onTap: () {
                      if (user != null) {
                        // Navegar a la pantalla de editar perfil solo si 'user' no es nulo
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Datos de usuario no disponibles')),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Cerrar Sesión'),
                    onTap: () => widget.logoutCallback(context), // Ejecuta el logout al hacer clic
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
