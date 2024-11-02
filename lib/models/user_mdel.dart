class UserModel {
  final String name;
  final String correo;
  final String title;
  final String imageUrl;
  final String descripcion;
  final String carrera;


  UserModel({
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.descripcion,
    required this.carrera,
    required this.correo,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'] ?? 'UsuarioNuevo',
      correo: data['correo'] ?? 'correo@algo',
      title: data['Titulo'] ?? 'Estudiante',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150', // URL de imagen por defecto
      carrera: data['carrera'] ?? 'Cuenta operativa',
      descripcion: data['descripcion'] ?? 'Cuentale a los demás acerca de tí',
    );
  }
}

