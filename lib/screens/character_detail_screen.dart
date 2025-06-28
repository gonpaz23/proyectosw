// lib/screens/character_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character.dart';
import '../providers/characters_provider.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Género', character.gender),
            _buildDetailRow('Altura', '${character.height} cm'),
            _buildDetailRow('Peso', '${character.mass} kg'),
            _buildDetailRow('Color de pelo', character.hairColor),
            _buildDetailRow('Color de piel', character.skinColor),
            _buildDetailRow('Color de ojos', character.eyeColor),
            _buildDetailRow('Año de nacimiento', character.birthYear),
            const SizedBox(height: 20),
            Center(
              child: Consumer<CharactersProvider>(
                builder: (context, provider, child) {
                  return FutureBuilder<bool>(
                    future: provider.isFavorite(character),
                    builder: (context, snapshot) {
                      final isFavorite = snapshot.data ?? false;
                      return ElevatedButton.icon(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        label: Text(isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos'),
                        onPressed: () {
                          provider.toggleFavorite(character);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}