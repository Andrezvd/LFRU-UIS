import 'package:lfru_app/models/grupos_model.dart';
class UserModel {
  final String name;
  final String correo;
  final String title;
  final String imageUrl;
  final String descripcion;
  final String carrera;
  final List<GruposModel> groups; 

  UserModel({
    required this.name,
    required this.correo,
    required this.title,
    required this.imageUrl,
    required this.descripcion,
    required this.carrera,
    this.groups = const [], 
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'] ?? 'UsuarioNuevo',
      correo: data['correo'] ?? 'correo@algo',
      title: data['Titulo'] ?? 'Estudiante',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
      carrera: data['carrera'] ?? 'Cuenta operativa',
      descripcion: data['descripcion'] ?? 'Cuentale a los demás acerca de ti',
      groups: (data['groups'] as List<dynamic>? ?? [])
          .map((groupData) => GruposModel.fromMap(groupData))
          .toList(), 
    );
  }
}
