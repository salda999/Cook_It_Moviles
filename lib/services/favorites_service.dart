import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites_recipes';
  static List<Recipe> _favoriteRecipes = [];
  
  /// Obtiene todas las recetas favoritas
  static List<Recipe> get favoriteRecipes => List.unmodifiable(_favoriteRecipes);
  
  /// Inicializa el servicio cargando favoritos desde SharedPreferences
  static Future<void> initialize() async {
    await _loadFavorites();
  }
  
  /// Carga las recetas favoritas desde SharedPreferences
  static Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
      
      _favoriteRecipes = favoritesJson
          .map((jsonString) => Recipe.fromJson(json.decode(jsonString)))
          .toList();
          
    } catch (e) {
      _favoriteRecipes = [];
    }
  }
  
  /// Guarda las recetas favoritas en SharedPreferences
  static Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = _favoriteRecipes
          .map((recipe) => json.encode(recipe.toJson()))
          .toList();
          
      await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      // Error saving favorites
    }
  }
  
  /// Verifica si una receta es favorita
  static bool isFavorite(String recipeId) {
    return _favoriteRecipes.any((recipe) => recipe.id == recipeId);
  }
  
  /// Agrega una receta a favoritos
  static Future<void> addToFavorites(Recipe recipe) async {
    if (!isFavorite(recipe.id)) {
      _favoriteRecipes.add(recipe);
      await _saveFavorites();
    }
  }
  
  /// Remueve una receta de favoritos
  static Future<void> removeFromFavorites(String recipeId) async {
    _favoriteRecipes.removeWhere((recipe) => recipe.id == recipeId);
    await _saveFavorites();
  }
  
  /// Alterna el estado de favorito de una receta
  static Future<void> toggleFavorite(Recipe recipe) async {
    if (isFavorite(recipe.id)) {
      await removeFromFavorites(recipe.id);
    } else {
      await addToFavorites(recipe);
    }
  }
  
  /// Limpia todos los favoritos
  static Future<void> clearAllFavorites() async {
    _favoriteRecipes.clear();
    await _saveFavorites();
  }
  
  /// Obtiene la cantidad de recetas favoritas
  static int get favoritesCount => _favoriteRecipes.length;
}