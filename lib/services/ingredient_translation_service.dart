import 'dart:convert';
import 'package:http/http.dart' as http;

class IngredientTranslationService {
  static const String _baseUrl = 'https://translate.googleapis.com/translate_a/single';
  
  // Cache para ingredientes traducidos
  static final Map<String, String> _ingredientsCache = {};
  
  /// Traduce un ingrediente individual del inglés al español
  static Future<String> translateIngredient(String ingredient) async {
    // Si está vacío, retornar tal como está
    if (ingredient.isEmpty) return ingredient;
    
    // Verificar si ya está en cache
    if (_ingredientsCache.containsKey(ingredient)) {
      return _ingredientsCache[ingredient]!;
    }
    
    try {
      
      final response = await http.get(
        Uri.parse('$_baseUrl?client=gtx&sl=en&tl=es&dt=t&q=${Uri.encodeComponent(ingredient)}'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded != null && decoded[0] != null && decoded[0][0] != null) {
          final translatedIngredient = decoded[0][0][0] as String;
          
          // Guardar en cache
          _ingredientsCache[ingredient] = translatedIngredient;
          
          return translatedIngredient;
        }
      }
    } catch (e) {
      // Error silently handled
    }
    
    // Si falla la traducción, retornar el ingrediente original
    return ingredient;
  }
  
  /// Traduce una medida del inglés al español
  static Future<String> translateMeasure(String measure) async {
    // Si está vacío, retornar tal como está
    if (measure.isEmpty) return measure;
    
    // Verificar si ya está en cache
    if (_ingredientsCache.containsKey(measure)) {
      return _ingredientsCache[measure]!;
    }
    
    try {
      
      final response = await http.get(
        Uri.parse('$_baseUrl?client=gtx&sl=en&tl=es&dt=t&q=${Uri.encodeComponent(measure)}'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded != null && decoded[0] != null && decoded[0][0] != null) {
          final translatedMeasure = decoded[0][0][0] as String;
          
          // Guardar en cache
          _ingredientsCache[measure] = translatedMeasure;
          
          return translatedMeasure;
        }
      }
    } catch (e) {
      // Error silently handled
    }
    
    // Si falla la traducción, retornar la medida original
    return measure;
  }
  
  /// Limpia el cache de traducciones (útil para testing)
  static void clearCache() {
    _ingredientsCache.clear();
  }
  
  /// Obtiene estadísticas del cache
  static void printCacheStats() {
    // Cache statistics available if needed
  }
}