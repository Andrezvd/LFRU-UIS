import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lfru_app/logica_solicitudes/aceptar_solicitud.dart';
import 'package:lfru_app/logica_solicitudes/borrar_notificacion.dart';
import 'package:lfru_app/logica_solicitudes/obtener_notificaciones.dart';
import 'package:lfru_app/logica_solicitudes/rechazar_solicitud.dart';
import 'package:lfru_app/models/notificaciones_model.dart';
import 'package:lfru_app/vistas/home/menu_lateral.dart';

class VerNotificaciones extends StatelessWidget {
  const VerNotificaciones({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  // Función para obtener las notificaciones del usuario
  Future<List<NotificacionesModel>> _obtenerNotificaciones(String correo) async {
    try {
      final obtenerNotificaciones = ObtenerNotificaciones();
      return obtenerNotificaciones.obtenerNotificaciones(correo);
    } catch (e) {
      print("Error obteniendo notificaciones: $e");
      return [];
    }
  }

  // Función para aceptar solicitud
  void _aceptarSolicitud(
      String idNotificacion, String correoOrigen, String correoDestino) {
    final aceptarSolicitudes = AceptarSolicitud();
    aceptarSolicitudes.aceptarSolicitud(
        idNotificacion, correoOrigen, correoOrigen);
  }

  // Función para rechazar solicitud
  void _rechazarSolicitud(
      String idNotificacion, String correoOrigen, String correoDestino) {
    RechazarSolicitud.rechazarSolicitud(
        idNotificacion, correoOrigen, correoDestino);
  }

  // Función para borrar notificación
  void _borrarNotificacion(String idNotificacion) {
    final borrarNotificacion = BorrarNotificacion();
    borrarNotificacion.borrarNotificaciones(idNotificacion);
  }

  @override
  Widget build(BuildContext context) {
    // Asumimos que el correo del usuario actual lo obtienes de Firebase Auth
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mis Notificaciones')),
        body: const Center(
          child: Text('No se encontró un usuario autenticado.'),
        ),
      );
    }

    final correoUsuario = user.email!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Notificaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: FutureBuilder<List<NotificacionesModel>>(
        future: _obtenerNotificaciones(correoUsuario),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text('Error al cargar las notificaciones'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes notificaciones'));
          }

          List<NotificacionesModel> notificaciones = snapshot.data!;

          return ListView.builder(
            itemCount: notificaciones.length,
            itemBuilder: (context, index) {
              NotificacionesModel notificacion = notificaciones[index];

              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4,
                child: ListTile(
                  title: Text(notificacion.titulo),
                  subtitle: Text(notificacion.cuerpo),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Botones para aceptar, rechazar y borrar
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              _aceptarSolicitud(notificacion.idNotificacion,
                                  notificacion.origen, notificacion.destino);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              _rechazarSolicitud(notificacion.idNotificacion,
                                  notificacion.origen, notificacion.destino);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey),
                            onPressed: () {
                              _borrarNotificacion(notificacion.idNotificacion);
                            },
                          ),
                        ],
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
