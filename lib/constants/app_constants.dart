// Constantes para la API de recetas - TheMealDB
class ApiConstants {
  // URL base para TheMealDB API
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  
  // Endpoints disponibles
  static const String searchByName = '/search.php?s=';
  static const String searchByFirstLetter = '/search.php?f=';
  static const String lookupById = '/lookup.php?i=';
  static const String randomMeal = '/random.php';
  static const String categories = '/categories.php';
  static const String listCategories = '/list.php?c=list';
  static const String listAreas = '/list.php?a=list';
  static const String listIngredients = '/list.php?i=list';
  static const String filterByIngredient = '/filter.php?i=';
  static const String filterByCategory = '/filter.php?c=';
  static const String filterByArea = '/filter.php?a=';
}

// Constantes para categorías de recetas - TheMealDB
class RecipeCategories {
  static const String beef = 'Beef';
  static const String chicken = 'Chicken';
  static const String dessert = 'Dessert';
  static const String lamb = 'Lamb';
  static const String miscellaneous = 'Miscellaneous';
  static const String pasta = 'Pasta';
  static const String pork = 'Pork';
  static const String seafood = 'Seafood';
  static const String side = 'Side';
  static const String starter = 'Starter';
  static const String vegan = 'Vegan';
  static const String vegetarian = 'Vegetarian';
  static const String breakfast = 'Breakfast';
  static const String goat = 'Goat';
}

// Constantes para el diseño de la app
class AppConstants {
  static const String appName = 'Cook It';
  static const int defaultPageSize = 20;
  static const Duration timeoutDuration = Duration(seconds: 30);
}