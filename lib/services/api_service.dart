import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class ApiService {
  static const String _baseUrl = 'https://swapi.info/api';
  static const int _timeoutSeconds = 10;

  Future<List<Character>> getCharacters() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/people/'),
      ).timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        if (results.isEmpty) return [];
        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar personajes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  Future<List<Character>> searchCharacters(String query) async {
    try {
      if (query.isEmpty) return await getCharacters();

      final response = await http.get(
        Uri.parse('$_baseUrl/people/?search=$query'),
      ).timeout(const Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        if (results.isEmpty) {
          throw Exception('No se encontraron personajes con "$query"');
        }
        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Error en la búsqueda: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al buscar: ${e.toString()}');
    }
  }
}