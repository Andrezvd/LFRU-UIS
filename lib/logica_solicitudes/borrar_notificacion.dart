import 'package:cloud_firestore/cloud_firestore.dart';

class BorrarNotificacion {
  Future<void> borrarNotificaciones(String idNotificacion) async {
    await FirebaseFirestore.instance.collection('notificaciones').doc(idNotificacion).delete();
  }
}