
class GruposModel {
  final String nombreGrupo;
  final String descripcionGrupo;
  final int cupos;
  final String facultad;
  final String escuela;
  final String materia;
  final String tema;

  GruposModel({
    required this.nombreGrupo,
    required this.descripcionGrupo,
    required this.cupos,
    required this.facultad,
    required this.escuela,
    required this.materia,
    required this.tema,
  });

  factory GruposModel.fromMap(Map<String, dynamic> data) {
    return GruposModel(
      nombreGrupo: data['nombre_grupo'] ?? 'Grupo nuevo',
      descripcionGrupo: data['descripcion_Grupo'] ?? 'Descripcion del grupo',
      cupos: data['cupos'] ?? 3, 
      facultad: data['facultad'] ?? 'Facultad',
      escuela: data['escuela'] ?? 'Cuentale a los demás acerca de tí',
      materia: data['materia'] ?? 'materia',
      tema: data['tema'] ?? 'tema',
    );
  }

}