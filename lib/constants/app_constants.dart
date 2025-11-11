// Constantes para la API de recetas
class ApiConstants {
  // URL base para la API (ejemplo: Spoonacular API)
  static const String baseUrl = 'https://api.spoonacular.com/recipes';
  
  // Tu API key (la agregarás más tarde)
  static const String apiKey = 'YOUR_API_KEY_HERE';
  
  // Endpoints
  static const String searchRecipes = '/complexSearch';
  static const String recipeInformation = '/information';
  static const String randomRecipes = '/random';
}

// Constantes para categorías de recetas
class RecipeCategories {
  static const String desserts = 'dessert';
  static const String mainCourse = 'main course';
  static const String appetizer = 'appetizer';
  static const String breakfast = 'breakfast';
  static const String soup = 'soup';
  static const String salad = 'salad';
  static const String side_dish = 'side dish';
  static const String drink = 'drink';
}

// Constantes para el diseño de la app
class AppConstants {
  static const String appName = 'Cook It';
  static const int defaultPageSize = 20;
  static const Duration timeoutDuration = Duration(seconds: 30);
}