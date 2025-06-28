class Character {
  final String name;
  final String gender;
  final String height;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String birthYear;
  final String url;

  Character({
    required this.name,
    required this.gender,
    required this.height,
    required this.mass,
    required this.hairColor,
    required this.skinColor,
    required this.eyeColor,
    required this.birthYear,
    required this.url,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? 'Desconocido',
      gender: json['gender'] ?? 'Desconocido',
      height: json['height'] ?? 'Desconocido',
      mass: json['mass'] ?? 'Desconocido',
      hairColor: json['hair_color'] ?? 'Desconocido',
      skinColor: json['skin_color'] ?? 'Desconocido',
      eyeColor: json['eye_color'] ?? 'Desconocido',
      birthYear: json['birth_year'] ?? 'Desconocido',
      url: json['url'] ?? '',
    );
  }
}