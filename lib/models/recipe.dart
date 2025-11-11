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
}

class Ingredient {
  final String name;
  final String measure;

  Ingredient({
    required this.name,
    required this.measure,
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