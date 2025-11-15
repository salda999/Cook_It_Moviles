import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../../services/favorites_service.dart';
import '../../theme/app_theme.dart';

import '../recipe_detail/recipe_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Recipe> _favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favoriteRecipes = FavoritesService.favoriteRecipes;
    });
  }

  void _onRecipeTap(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    ).then((_) {
      // Recargar favoritos cuando se regrese de la pantalla de detalles
      _loadFavorites();
    });
  }

  Future<void> _removeFromFavorites(Recipe recipe) async {
    await FavoritesService.removeFromFavorites(recipe.id);
    _loadFavorites();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${recipe.name} eliminado de favoritos'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () async {
              await FavoritesService.addToFavorites(recipe);
              _loadFavorites();
            },
          ),
        ),
      );
    }
  }

  Future<void> _clearAllFavorites() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar todos los favoritos'),
          content: const Text('¿Estás seguro de que quieres eliminar todas las recetas favoritas?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FavoritesService.clearAllFavorites();
                _loadFavorites();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todos los favoritos han sido eliminados'),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Favoritos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          if (_favoriteRecipes.isNotEmpty)
            IconButton(
              onPressed: _clearAllFavorites,
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Eliminar todos',
            ),
        ],
      ),
      body: _favoriteRecipes.isEmpty ? _buildEmptyState() : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes favoritos aún',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explora recetas y marca las que más te gusten\ncon el ícono de corazón',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.explore),
            label: const Text('Explorar Recetas'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.favorite,
                color: Colors.pink,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${_favoriteRecipes.length} receta${_favoriteRecipes.length != 1 ? 's' : ''} favorita${_favoriteRecipes.length != 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _favoriteRecipes.length,
            itemBuilder: (context, index) {
              final recipe = _favoriteRecipes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      recipe.image ?? '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.restaurant),
                        );
                      },
                    ),
                  ),
                  title: Text(
                    recipe.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (recipe.category != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          recipe.category!,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (recipe.area != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          recipe.area!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () => _removeFromFavorites(recipe),
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.pink,
                    ),
                    tooltip: 'Eliminar de favoritos',
                  ),
                  onTap: () => _onRecipeTap(recipe),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}