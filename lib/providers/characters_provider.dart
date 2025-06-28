import 'package:flutter/foundation.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import '../services/firebase_service.dart';

class CharactersProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FirebaseService _firebaseService = FirebaseService();
  
  List<Character> _characters = [];
  List<Character> _filteredCharacters = [];
  bool _isLoading = false;
  String _searchQuery = '';
  final String _userId = 'user1'; // En una app real, usarías autenticación

  List<Character> get characters => _searchQuery.isEmpty ? _characters : _filteredCharacters;
  bool get isLoading => _isLoading;

  CharactersProvider() {
    loadCharacters();
  }

  Future<void> loadCharacters() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _characters = await _apiService.getCharacters();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading characters: $e');
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchCharacters(String query) async {
    _searchQuery = query;
    _isLoading = true;
    notifyListeners();
    
    if (query.isEmpty) {
      _filteredCharacters = [];
    } else {
      try {
        _filteredCharacters = await _apiService.searchCharacters(query);
      } catch (e) {
        if (kDebugMode) {
          print('Error searching characters: $e');
        }
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(Character character) async {
    final isFavorite = await _firebaseService.isFavorite(character, _userId);
    if (isFavorite) {
      await _firebaseService.removeFavorite(character, _userId);
    } else {
      await _firebaseService.addFavorite(character, _userId);
    }
    notifyListeners();
  }

  Future<bool> isFavorite(Character character) async {
    return await _firebaseService.isFavorite(character, _userId);
  }

  Future<List<Character>> getFavorites() async {
    return await _firebaseService.getFavorites(_userId);
  }
}