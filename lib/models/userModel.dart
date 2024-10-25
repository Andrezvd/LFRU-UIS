class UserModel {
  final String name;
  final String title;
  final String imageUrl;

  UserModel({
    required this.name,
    required this.title,
    required this.imageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['usuario'] ?? 'Nombre por defecto',
      title: data['Titulo'] ?? 'Título por defecto',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150', // URL de imagen por defecto
    );
  }
}