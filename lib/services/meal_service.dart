import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/recipe.dart';
import 'instruction_translation_service.dart';
import 'ingredient_translation_service.dart';

class MealService {
  static const String baseUrl = ApiConstants.baseUrl;

  // Buscar comida por nombre
  static Future<List<Recipe>> searchMealsByName(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.searchByName}$name'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((meal) => Recipe.fromJson(meal))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching meals by name: $e');
      return [];
    }
  }

  // Buscar comidas por primera letra
  static Future<List<Recipe>> searchMealsByFirstLetter(String letter) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.searchByFirstLetter}$letter'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((meal) => Recipe.fromJson(meal))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching meals by first letter: $e');
      return [];
    }
  }

  // Obtener detalles completos de una comida por ID
  static Future<Recipe?> getMealById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.lookupById}$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          final recipe = Recipe.fromJson(data['meals'][0]);
          
          // Traducir automáticamente las instrucciones e ingredientes
          final recipeWithTranslatedContent = await translateRecipeContent(recipe);
          
          return recipeWithTranslatedContent;
        }
      }
      return null;
    } catch (e) {
      print('Error getting meal by ID: $e');
      return null;
    }
  }

  // Obtener una comida aleatoria
  static Future<Recipe?> getRandomMeal() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.randomMeal}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          final recipe = Recipe.fromJson(data['meals'][0]);
          
          // Traducir automáticamente las instrucciones e ingredientes
          final recipeWithTranslatedContent = await translateRecipeContent(recipe);
          
          return recipeWithTranslatedContent;
        }
      }
      return null;
    } catch (e) {
      print('Error getting random meal: $e');
      return null;
    }
  }

  // Obtener todas las categorías
  static Future<List<MealCategory>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.categories}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['categories'] != null) {
          return (data['categories'] as List)
              .map((category) => MealCategory.fromJson(category))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  // Obtener lista de categorías simples
  static Future<List<String>> getCategoryList() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.listCategories}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((item) => item['strCategory'] as String)
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting category list: $e');
      return [];
    }
  }

  // Obtener lista de áreas
  static Future<List<MealArea>> getAreas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.listAreas}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((area) => MealArea.fromJson(area))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting areas: $e');
      return [];
    }
  }

  // Obtener lista de ingredientes
  static Future<List<MealIngredient>> getIngredients() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.listIngredients}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((ingredient) => MealIngredient.fromJson(ingredient))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting ingredients: $e');
      return [];
    }
  }

  // Filtrar por ingrediente principal
  static Future<List<Recipe>> filterByIngredient(String ingredient) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.filterByIngredient}$ingredient'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          // Los filtros devuelven información limitada, necesitamos obtener detalles completos
          List<Recipe> meals = [];
          for (var meal in data['meals']) {
            final fullMeal = await getMealById(meal['idMeal']);
            if (fullMeal != null) {
              meals.add(fullMeal);
            }
          }
          return meals;
        }
      }
      return [];
    } catch (e) {
      print('Error filtering by ingredient: $e');
      return [];
    }
  }

  // Filtrar por categoría
  static Future<List<Recipe>> filterByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.filterByCategory}$category'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          // Los filtros devuelven información limitada, solo tomamos los primeros 20 para evitar demasiadas llamadas
          List<Recipe> meals = [];
          final limitedMeals = (data['meals'] as List).take(20);
          
          for (var meal in limitedMeals) {
            final fullMeal = await getMealById(meal['idMeal']);
            if (fullMeal != null) {
              meals.add(fullMeal);
            }
          }
          return meals;
        }
      }
      return [];
    } catch (e) {
      print('Error filtering by category: $e');
      return [];
    }
  }

  // Filtrar por área
  static Future<List<Recipe>> filterByArea(String area) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConstants.filterByArea}$area'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          // Los filtros devuelven información limitada, solo tomamos los primeros 20 para evitar demasiadas llamadas
          List<Recipe> meals = [];
          final limitedMeals = (data['meals'] as List).take(20);
          
          for (var meal in limitedMeals) {
            final fullMeal = await getMealById(meal['idMeal']);
            if (fullMeal != null) {
              meals.add(fullMeal);
            }
          }
          return meals;
        }
      }
      return [];
    } catch (e) {
      print('Error filtering by area: $e');
      return [];
    }
  }

  // Obtener imagen con tamaño específico
  static String getMealImageWithSize(String imageUrl, String size) {
    // size puede ser: small, medium, large
    if (imageUrl.isEmpty) return imageUrl;
    
    // Eliminar la extensión si existe
    String baseUrl = imageUrl.replaceAll(RegExp(r'\.(jpg|jpeg|png)$'), '');
    return '$baseUrl/$size';
  }
  
  // MÉTODO PARA TRADUCIR INSTRUCCIONES AUTOMÁTICAMENTE
  
  /// Traduce las instrucciones de una receta automáticamente
  static Future<Recipe> translateRecipeInstructions(Recipe recipe) async {
    // Si no hay instrucciones, retornar la receta tal como está
    if (recipe.instructions == null || recipe.instructions!.isEmpty) {
      return recipe;
    }
    
    try {
      // Traducir las instrucciones usando el servicio de traducción
      final translatedInstructions = await InstructionTranslationService.translateInstructions(
        recipe.instructions!
      );
      
      // Crear una nueva instancia de Recipe con las instrucciones traducidas
      return recipe.copyWithTranslatedInstructions(translatedInstructions);
      
    } catch (e) {
      // Si falla, retornar la receta original
      return recipe;
    }
  }
  
  /// Traduce los ingredientes de una receta automáticamente
  static Future<Recipe> translateRecipeIngredients(Recipe recipe) async {
    // Si no hay ingredientes, retornar la receta tal como está
    if (recipe.ingredients.isEmpty) {
      return recipe;
    }
    
    try {
      // Lista para almacenar los ingredientes traducidos
      List<Ingredient> translatedIngredients = [];
      
      // Traducir cada ingrediente
      for (Ingredient ingredient in recipe.ingredients) {
        String? translatedName;
        String? translatedMeasure;
        
        // Traducir el nombre del ingrediente si no está vacío
        if (ingredient.name.isNotEmpty) {
          translatedName = await IngredientTranslationService.translateIngredient(ingredient.name);
        }
        
        // Traducir la medida si no está vacía
        if (ingredient.measure.isNotEmpty) {
          translatedMeasure = await IngredientTranslationService.translateMeasure(ingredient.measure);
        }
        
        // Crear un nuevo ingrediente con las traducciones
        translatedIngredients.add(ingredient.copyWith(
          nameSpanish: translatedName,
          measureSpanish: translatedMeasure,
        ));
      }
      
      // Crear una nueva instancia de Recipe con los ingredientes traducidos
      return recipe.copyWithTranslatedIngredients(translatedIngredients);
      
    } catch (e) {
      // Si falla, retornar la receta original
      return recipe;
    }
  }
  
  /// Traduce tanto instrucciones como ingredientes de una receta automáticamente
  static Future<Recipe> translateRecipeContent(Recipe recipe) async {
    try {
      // Primero traducir las instrucciones
      Recipe recipeWithInstructions = await translateRecipeInstructions(recipe);
      
      // Luego traducir los ingredientes
      Recipe recipeWithFullTranslation = await translateRecipeIngredients(recipeWithInstructions);
      
      return recipeWithFullTranslation;
      
    } catch (e) {
      // Si falla, retornar la receta original
      return recipe;
    }
  }
}