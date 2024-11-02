class NotificacionesModel {

  final String origen;
  final String destino;
  final String asunto;
  final String cuerpo;

  NotificacionesModel({
    required this.origen,
    required this.destino,
    required this.asunto,
    required this.cuerpo,
  });

  factory NotificacionesModel.fromMap(Map<String,dynamic> data){
    return NotificacionesModel(
      origen: data['origen'],
      destino: data['destino'],
      asunto: data['asunto'],
      cuerpo: data['cuerpo']
    );
  }

}