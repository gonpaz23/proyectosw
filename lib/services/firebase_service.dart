import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/character.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFavorite(Character character, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(character.url.split('/').reversed.toList()[1])
        .set(character.toJson());
  }

  Future<void> removeFavorite(Character character, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(character.url.split('/').reversed.toList()[1])
        .delete();
  }

  Future<List<Character>> getFavorites(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();
    return snapshot.docs
        .map((doc) => Character.fromJson(doc.data()))
        .toList();
  }

  Future<bool> isFavorite(Character character, String userId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(character.url.split('/').reversed.toList()[1])
        .get();
    return doc.exists;
  }
}

extension CharacterExtensions on Character {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'height': height,
      'mass': mass,
      'hair_color': hairColor,
      'skin_color': skinColor,
      'eye_color': eyeColor,
      'birth_year': birthYear,
      'url': url,
    };
  }
}