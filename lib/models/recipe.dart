class Recipe {
  final String id;
  final String name;
  final String? drinkAlternate;
  final String? category;
  final String? area;
  final String? instructions;
  final String? image;
  final String? tags;
  final String? youtube;
  final List<Ingredient> ingredients;
  final String? source;
  final String? imageSource;
  final String? creativeCommonsConfirmed;
  final String? dateModified;
  
  // Campos para contenido traducido
  final String? instructionsSpanish;
  final List<Ingredient>? ingredientsSpanish;

  Recipe({
    required this.id,
    required this.name,
    this.drinkAlternate,
    this.category,
    this.area,
    this.instructions,
    this.image,
    this.tags,
    this.youtube,
    required this.ingredients,
    this.source,
    this.imageSource,
    this.creativeCommonsConfirmed,
    this.dateModified,
    this.instructionsSpanish,
    this.ingredientsSpanish,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredients = [];
    
    // TheMealDB estructura los ingredientes de forma especial (strIngredient1, strMeasure1, etc.)
    for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];
      
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add(Ingredient(
          name: ingredient.trim(),
          measure: measure?.trim() ?? '',
        ));
      }
    }

    return Recipe(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      drinkAlternate: json['strDrinkAlternate'],
      category: json['strCategory'],
      area: json['strArea'],
      instructions: json['strInstructions'],
      image: json['strMealThumb'],
      tags: json['strTags'],
      youtube: json['strYoutube'],
      ingredients: ingredients,
      source: json['strSource'],
      imageSource: json['strImageSource'],
      creativeCommonsConfirmed: json['strCreativeCommonsConfirmed'],
      dateModified: json['dateModified'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'idMeal': id,
      'strMeal': name,
      'strDrinkAlternate': drinkAlternate,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': image,
      'strTags': tags,
      'strYoutube': youtube,
      'strSource': source,
      'strImageSource': imageSource,
      'strCreativeCommonsConfirmed': creativeCommonsConfirmed,
      'dateModified': dateModified,
    };

    // Agregar ingredientes en el formato de TheMealDB
    for (int i = 0; i < ingredients.length && i < 20; i++) {
      json['strIngredient${i + 1}'] = ingredients[i].name;
      json['strMeasure${i + 1}'] = ingredients[i].measure;
    }

    return json;
  }

  // Getter para obtener las tags como lista
  List<String> get tagsList {
    if (tags == null || tags!.isEmpty) return [];
    return tags!.split(',').map((tag) => tag.trim()).toList();
  }

  // Getter para obtener las instrucciones como lista de pasos
  List<String> get instructionSteps {
    if (instructions == null || instructions!.isEmpty) return [];
    return instructions!
        .split('\r\n')
        .where((step) => step.trim().isNotEmpty)
        .map((step) => step.trim())
        .toList();
  }
  
  // Getters para instrucciones traducidas
  
  /// Retorna las instrucciones en español si están disponibles, sino las originales
  String? get displayInstructions => instructionsSpanish ?? instructions;
  
  /// Retorna los ingredientes en español si están disponibles, sino los originales
  List<Ingredient> get displayIngredients => ingredientsSpanish ?? ingredients;
  
  /// Retorna las instrucciones traducidas como lista de pasos
  List<String> get displayInstructionSteps {
    final instructionsToUse = displayInstructions;
    if (instructionsToUse == null || instructionsToUse.isEmpty) return [];
    return instructionsToUse
        .split('\r\n')
        .where((step) => step.trim().isNotEmpty)
        .map((step) => step.trim())
        .toList();
  }
  
  /// Crea una copia de la receta con contenido traducido
  Recipe copyWithTranslatedContent({
    String? translatedInstructions,
    List<Ingredient>? translatedIngredients,
  }) {
    return Recipe(
      id: id,
      name: name,
      drinkAlternate: drinkAlternate,
      category: category,
      area: area,
      instructions: instructions,
      image: image,
      tags: tags,
      youtube: youtube,
      ingredients: ingredients,
      source: source,
      imageSource: imageSource,
      creativeCommonsConfirmed: creativeCommonsConfirmed,
      dateModified: dateModified,
      instructionsSpanish: translatedInstructions ?? instructionsSpanish,
      ingredientsSpanish: translatedIngredients ?? ingredientsSpanish,
    );
  }
  
  /// Crea una copia de la receta con instrucciones traducidas (mantener compatibilidad)
  Recipe copyWithTranslatedInstructions(String translatedInstructions) {
    return copyWithTranslatedContent(translatedInstructions: translatedInstructions);
  }
  
  /// Crea una copia de la receta con ingredientes traducidos
  Recipe copyWithTranslatedIngredients(List<Ingredient> translatedIngredients) {
    return copyWithTranslatedContent(translatedIngredients: translatedIngredients);
  }
}

class Ingredient {
  final String name;
  final String measure;
  final String? nameSpanish;
  final String? measureSpanish;

  Ingredient({
    required this.name,
    required this.measure,
    this.nameSpanish,
    this.measureSpanish,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      measure: json['measure'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'measure': measure,
    };
  }

  @override
  String toString() {
    return measure.isEmpty ? name : '$measure $name';
  }
  
  /// Retorna el nombre en español si está disponible, sino el original
  String get displayName => nameSpanish ?? name;
  
  /// Retorna la medida en español si está disponible, sino la original
  String get displayMeasure => measureSpanish ?? measure;
  
  /// Retorna la representación completa en español si está disponible
  String get displayString {
    final dMeasure = displayMeasure;
    final dName = displayName;
    return dMeasure.isEmpty ? dName : '$dMeasure $dName';
  }
  
  /// Crea una copia del ingrediente con los valores especificados
  Ingredient copyWith({
    String? name,
    String? measure,
    String? nameSpanish,
    String? measureSpanish,
  }) {
    return Ingredient(
      name: name ?? this.name,
      measure: measure ?? this.measure,
      nameSpanish: nameSpanish ?? this.nameSpanish,
      measureSpanish: measureSpanish ?? this.measureSpanish,
    );
  }
}

// Modelos adicionales para TheMealDB

class MealCategory {
  final String id;
  final String name;
  final String image;
  final String description;

  MealCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      id: json['idCategory'] ?? '',
      name: json['strCategory'] ?? '',
      image: json['strCategoryThumb'] ?? '',
      description: json['strCategoryDescription'] ?? '',
    );
  }
}

class MealArea {
  final String name;

  MealArea({required this.name});

  factory MealArea.fromJson(Map<String, dynamic> json) {
    return MealArea(name: json['strArea'] ?? '');
  }
}

class MealIngredient {
  final String id;
  final String name;
  final String? description;
  final String? type;

  MealIngredient({
    required this.id,
    required this.name,
    this.description,
    this.type,
  });

  factory MealIngredient.fromJson(Map<String, dynamic> json) {
    return MealIngredient(
      id: json['idIngredient'] ?? '',
      name: json['strIngredient'] ?? '',
      description: json['strDescription'],
      type: json['strType'],
    );
  }
}