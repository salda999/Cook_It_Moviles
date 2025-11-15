import 'dart:convert';
import 'package:http/http.dart' as http;

class InstructionTranslationService {
  static const String _baseUrl = 'https://translate.googleapis.com/translate_a/single';
  
  // Cache simple para evitar traducir las mismas instrucciones múltiples veces
  static final Map<String, String> _instructionsCache = {};
  
  /// Traduce solo las instrucciones de una receta del inglés al español
  /// Preserva la estructura de pasos separados por \r\n
  static Future<String> translateInstructions(String instructions) async {
    // Si está vacío, retornar tal como está
    if (instructions.isEmpty) return instructions;
    
    // Verificar si ya está en cache
    if (_instructionsCache.containsKey(instructions)) {
      return _instructionsCache[instructions]!;
    }
    
    try {
      // Dividir las instrucciones en pasos individuales
      final steps = instructions.split('\r\n').where((step) => step.trim().isNotEmpty).toList();
      
      if (steps.isEmpty) return instructions;
      
      // Si solo hay un paso, traducir directamente
      if (steps.length == 1) {
        return await _translateSingleText(steps[0]);
      }
      
      // Traducir cada paso individualmente
      final translatedSteps = <String>[];
      
      for (String step in steps) {
        if (step.trim().isNotEmpty) {
          final translatedStep = await _translateSingleText(step.trim());
          translatedSteps.add(translatedStep);
          
          // Pausa optimizada para velocidad y estabilidad
          await Future.delayed(const Duration(milliseconds: 80));
        }
      }
      
      // Reconstruir las instrucciones con la estructura original
      final reconstructedInstructions = translatedSteps.join('\r\n');
      
      // Guardar en cache
      _instructionsCache[instructions] = reconstructedInstructions;
      
      return reconstructedInstructions;
      
    } catch (e) {
      // Error silently handled
    }
    
    // Si falla la traducción, retornar las instrucciones originales
    return instructions;
  }
  
  /// Traduce un texto individual
  static Future<String> _translateSingleText(String text) async {
    if (text.isEmpty) return text;
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?client=gtx&sl=en&tl=es&dt=t&q=${Uri.encodeComponent(text)}'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded != null && decoded[0] != null && decoded[0][0] != null) {
          return decoded[0][0][0] as String;
        }
      }
    } catch (e) {
      // Error silently handled
    }
    
    // Si falla, retornar texto original
    return text;
  }
  
  /// Limpia el cache de traducciones (útil para testing)
  static void clearCache() {
    _instructionsCache.clear();
  }
  
  /// Obtiene estadísticas del cache
  static void printCacheStats() {
    // Cache statistics available if needed
  }
}