import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lfru_app/models/grupos_model.dart';
import 'package:lfru_app/models/user_mdel.dart';
import 'package:lfru_app/models/notificaciones_model.dart';

class AceptarSolicitud {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Aceptar solicitud
    void aceptarSolicitud(String idNotificacion, String idUsuarioOrigen, String idGrupo) async {
    try {
      // 1. Obtener el usuario que envió la solicitud
      DocumentSnapshot userSnapshot = await _firestore.collection('usuarios').doc(idUsuarioOrigen).get();
      if (!userSnapshot.exists) {
        print('Usuario no encontrado');
        return;
      }

      // Obtener datos del usuario
      UserModel user = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

      // 2. Obtener el grupo
      DocumentSnapshot groupSnapshot = await _firestore.collection('grupos').doc(idGrupo).get();
      if (!groupSnapshot.exists) {
        print('Grupo no encontrado');
        return;
      }

      // Obtener datos del grupo
      GruposModel group = GruposModel.fromMap(groupSnapshot.data() as Map<String, dynamic>);

      // 3. Añadir el grupo al usuario (a su lista de grupos)
      if (!user.groups.any((g) => g.idGrupo == idGrupo)) {
        user.groups.add(group); // Añadir el grupo al usuario
      }

      // 4. Actualizar el usuario con el nuevo grupo
      await _firestore.collection('usuarios').doc(idUsuarioOrigen).update({
        'groups': user.groups.map((group) => group.toMap()).toList(),
      });

      // 5. Disminuir el número de cupos disponibles del grupo
      if (group.cupos > 0) {
        group.cupos -= 1;
      } else {
        print('No hay cupos disponibles');
        return;
      }

      // 6. Actualizar el grupo con los nuevos cupos
      await _firestore.collection('grupos').doc(idGrupo).update({
        'cuposDisponibles': group.cupos,
        'miembros': FieldValue.arrayUnion([idUsuarioOrigen]), // Agregar al usuario a la lista de miembros
      });

      // 7. Enviar notificación al usuario que realizó la solicitud
      final nuevaNotificacion = NotificacionesModel(
        idNotificacion: UniqueKey().toString(),
        origen: idUsuarioOrigen,
        destino: idUsuarioOrigen,
        tipo: 'solicitud_aceptada',
        titulo: 'Solicitud aceptada',
        cuerpo: '¡Felicidades! Ahora eres miembro del grupo ${group.nombreGrupo}.',
        fecha: DateTime.now(),
      );

      // Guardar la notificación
      await _firestore.collection('notificaciones').add(nuevaNotificacion.toJson());

      // 8. Eliminar la notificación original
      await _firestore.collection('notificaciones').doc(idNotificacion).delete();

      print('Solicitud aceptada, grupo añadido al usuario y notificación enviada');
    } catch (e) {
      print('Error al aceptar la solicitud: $e');
    }
  }
}
