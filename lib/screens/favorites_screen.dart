import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character.dart';
import '../providers/characters_provider.dart';
import 'character_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personajes Favoritos'),
      ),
      body: FutureBuilder<List<Character>>(
        future: Provider.of<CharactersProvider>(context, listen: false).getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes personajes favoritos'));
          }
          
          final favorites = snapshot.data!;
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final character = favorites[index];
              return ListTile(
                title: Text(character.name),
                subtitle: Text('Género: ${character.gender}'),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    Provider.of<CharactersProvider>(context, listen: false)
                        .toggleFavorite(character);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CharacterDetailScreen(character: character),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}