import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
 
class ApiService {
  // Multiple working SWAPI endpoints as fallbacks
  static const List<String> _baseUrls = [
    'https://swapi.py4e.com/api',
    'https://swapi.dev/api',
    'https://swapi.tech/api',
    'https://swapi.info/api',
  ];
 
  static const int _timeoutSeconds = 10;
 
  // Track which endpoint is currently working
  static String? _workingBaseUrl;
 
  /// Try each endpoint until one works
  Future<String> _getWorkingEndpoint() async {
    // If we already found a working endpoint, use it
    if (_workingBaseUrl != null) {
      return _workingBaseUrl!;
    }
 
    for (String baseUrl in _baseUrls) {
      try {
        print('Testing endpoint: $baseUrl');
        final response = await http
            .get(Uri.parse('$baseUrl/people/1/'))
            .timeout(const Duration(seconds: 5));
 
        if (response.statusCode == 200) {
          print('Working endpoint found: $baseUrl');
          _workingBaseUrl = baseUrl;
          return baseUrl;
        }
      } catch (e) {
        print('Endpoint $baseUrl failed: $e');
        continue;
      }
    }
 
    throw Exception('All SWAPI endpoints are currently unavailable');
  }
 
  Future<List<Character>> getCharacters() async {
    try {
      final baseUrl = await _getWorkingEndpoint();
      print('Making request to: $baseUrl/people/');
 
      final response = await http
          .get(Uri.parse('$baseUrl/people/'))
          .timeout(const Duration(seconds: _timeoutSeconds));
 
      print('Response status code: ${response.statusCode}');
      print('Raw response body: ${response.body}');
 
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
 
        print('Decoded JSON type: ${data.runtimeType}');
 
        // Handle different response structures from different SWAPI implementations
        List<dynamic> results = [];
 
        if (data is Map<String, dynamic>) {
          print('Available keys: ${data.keys.toList()}');
 
          // Standard SWAPI structure
          if (data.containsKey('results') && data['results'] is List) {
            results = data['results'] as List;
            print('Using standard SWAPI results field');
          }
          // Alternative structure
          else if (data.containsKey('data') && data['data'] is List) {
            results = data['data'] as List;
            print('Using data field');
          }
          // Single character endpoint (some APIs return direct character data)
          else if (data.containsKey('name')) {
            results = [data];
            print('Using single character response');
          }
        } else if (data is List) {
          results = data;
          print('Using direct list response');
        }
 
        print('Found ${results.length} results');
 
        if (results.isEmpty) return [];
 
        // Print first result structure for debugging
        if (results.isNotEmpty) {
          print('First result structure: ${results[0]}');
        }
 
        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        // If this endpoint fails, try the next one
        print(
          'Endpoint failed with status ${response.statusCode}, trying next...',
        );
        _workingBaseUrl = null; // Reset to try other endpoints
        return await getCharacters();
      }
    } catch (e) {
      print('Full error details: $e');
 
      // If current endpoint fails, reset and try again
      if (_workingBaseUrl != null) {
        print('Current endpoint failed, resetting and trying alternatives...');
        _workingBaseUrl = null;
        return await getCharacters();
      }
 
      rethrow;
    }
  }
 
  Future<List<Character>> searchCharacters(String query) async {
    try {
      if (query.isEmpty) return await getCharacters();
 
      final baseUrl = await _getWorkingEndpoint();
      print('Making search request to: $baseUrl/people/?search=$query');
 
      final response = await http
          .get(Uri.parse('$baseUrl/people/?search=$query'))
          .timeout(const Duration(seconds: _timeoutSeconds));
 
      print('Response status code: ${response.statusCode}');
      print('Raw response body: ${response.body}');
 
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
 
        print('Decoded JSON type: ${data.runtimeType}');
 
        List<dynamic> results = [];
 
        if (data is Map<String, dynamic>) {
          print('Available keys: ${data.keys.toList()}');
 
          if (data.containsKey('results') && data['results'] is List) {
            results = data['results'] as List;
            print('Using standard SWAPI results field');
          } else if (data.containsKey('data') && data['data'] is List) {
            results = data['data'] as List;
            print('Using data field');
          } else if (data.containsKey('name')) {
            results = [data];
            print('Using single character response');
          }
        } else if (data is List) {
          results = data;
          print('Using direct list response');
        }
 
        print('Found ${results.length} results');
 
        if (results.isEmpty) {
          throw Exception('No se encontraron personajes con "$query"');
        }
 
        if (results.isNotEmpty) {
          print('First result structure: ${results[0]}');
        }
 
        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        print(
          'Search endpoint failed with status ${response.statusCode}, trying next...',
        );
        _workingBaseUrl = null;
        return await searchCharacters(query);
      }
    } catch (e) {
      print('Full search error details: $e');
 
      if (_workingBaseUrl != null) {
        print(
          'Current endpoint failed during search, resetting and trying alternatives...',
        );
        _workingBaseUrl = null;
        return await searchCharacters(query);
      }
 
      rethrow;
    }
  }
 
  /// Get a specific character by ID
  Future<Character?> getCharacterById(int id) async {
    try {
      final baseUrl = await _getWorkingEndpoint();
      print('Making request to: $baseUrl/people/$id/');
 
      final response = await http
          .get(Uri.parse('$baseUrl/people/$id/'))
          .timeout(const Duration(seconds: _timeoutSeconds));
 
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Character.fromJson(data);
      } else if (response.statusCode == 404) {
        return null; // Character not found
      } else {
        _workingBaseUrl = null;
        return await getCharacterById(id);
      }
    } catch (e) {
      print('Error getting character by ID: $e');
      if (_workingBaseUrl != null) {
        _workingBaseUrl = null;
        return await getCharacterById(id);
      }
      return null;
    }
  }
 
  /// Test connectivity to all endpoints and return status
  Future<Map<String, bool>> testAllEndpoints() async {
    Map<String, bool> endpointStatus = {};
 
    for (String baseUrl in _baseUrls) {
      try {
        final response = await http
            .get(Uri.parse('$baseUrl/people/1/'))
            .timeout(const Duration(seconds: 5));
 
        endpointStatus[baseUrl] = response.statusCode == 200;
      } catch (e) {
        endpointStatus[baseUrl] = false;
      }
    }
 
    return endpointStatus;
  }
}