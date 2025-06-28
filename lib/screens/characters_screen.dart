import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/characters_provider.dart';
import 'character_detail_screen.dart';
import 'favorites_screen.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Provider.of<CharactersProvider>(context, listen: false)
        .searchCharacters(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personajes de Star Wars'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar personaje',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Consumer<CharactersProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.characters.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.characters.isEmpty) {
                  return const Center(child: Text('No se encontraron personajes'));
                }
                
                return ListView.builder(
                  itemCount: provider.characters.length,
                  itemBuilder: (context, index) {
                    final character = provider.characters[index];
                    return FutureBuilder<bool>(
                      future: provider.isFavorite(character),
                      builder: (context, snapshot) {
                        final isFavorite = snapshot.data ?? false;
                        return ListTile(
                          title: Text(character.name),
                          subtitle: Text('Género: ${character.gender}'),
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            onPressed: () {
                              provider.toggleFavorite(character);
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}