import 'package:flutter/material.dart';
import 'package:lfru_app/logica_solicitudes/guardar_notificacion_db.dart';
import 'package:lfru_app/models/notificaciones_model.dart';

class SolicitarUnirse {
  static Future<void> solicitarUnirse(
      String idUsuarioOrigen, String idGrupo, String idPropietarioGrupo) async {
    final nuevaNotificacion = NotificacionesModel(
      idNotificacion: UniqueKey().toString(), // Genera un ID único
      origen: idUsuarioOrigen,
      destino: idPropietarioGrupo,
      tipo: 'solicitud_grupo',
      titulo: 'Nueva solicitud para tu grupo',
      cuerpo: 'El usuario $idUsuarioOrigen desea unirse al grupo $idGrupo.',
      fecha: DateTime.now(),
      leida: false,
    );

    // Guardar la notificación en la base de datos
    await GuardarNotificacionDb.guardarNotificacion(nuevaNotificacion);
  }
}
