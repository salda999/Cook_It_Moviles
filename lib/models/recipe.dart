class Recipe {
  final int id;
  final String title;
  final String? image;
  final int readyInMinutes;
  final int servings;
  final String? summary;
  final List<String> dishTypes;
  final List<Ingredient>? extendedIngredients;
  final List<InstructionStep>? analyzedInstructions;
  final bool vegetarian;
  final bool vegan;
  final bool glutenFree;
  final bool dairyFree;
  final double? spoonacularScore;
  final double? healthScore;

  Recipe({
    required this.id,
    required this.title,
    this.image,
    required this.readyInMinutes,
    required this.servings,
    this.summary,
    required this.dishTypes,
    this.extendedIngredients,
    this.analyzedInstructions,
    required this.vegetarian,
    required this.vegan,
    required this.glutenFree,
    required this.dairyFree,
    this.spoonacularScore,
    this.healthScore,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'],
      readyInMinutes: json['readyInMinutes'] ?? 0,
      servings: json['servings'] ?? 0,
      summary: json['summary'],
      dishTypes: List<String>.from(json['dishTypes'] ?? []),
      extendedIngredients: json['extendedIngredients'] != null
          ? (json['extendedIngredients'] as List)
              .map((ingredient) => Ingredient.fromJson(ingredient))
              .toList()
          : null,
      analyzedInstructions: json['analyzedInstructions'] != null
          ? (json['analyzedInstructions'] as List)
              .expand((instruction) => (instruction['steps'] as List))
              .map((step) => InstructionStep.fromJson(step))
              .toList()
          : null,
      vegetarian: json['vegetarian'] ?? false,
      vegan: json['vegan'] ?? false,
      glutenFree: json['glutenFree'] ?? false,
      dairyFree: json['dairyFree'] ?? false,
      spoonacularScore: json['spoonacularScore']?.toDouble(),
      healthScore: json['healthScore']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'readyInMinutes': readyInMinutes,
      'servings': servings,
      'summary': summary,
      'dishTypes': dishTypes,
      'vegetarian': vegetarian,
      'vegan': vegan,
      'glutenFree': glutenFree,
      'dairyFree': dairyFree,
      'spoonacularScore': spoonacularScore,
      'healthScore': healthScore,
    };
  }
}

class Ingredient {
  final int id;
  final String name;
  final String original;
  final double amount;
  final String unit;
  final String? image;

  Ingredient({
    required this.id,
    required this.name,
    required this.original,
    required this.amount,
    required this.unit,
    this.image,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      original: json['original'] ?? '',
      amount: json['amount']?.toDouble() ?? 0.0,
      unit: json['unit'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'original': original,
      'amount': amount,
      'unit': unit,
      'image': image,
    };
  }
}

class InstructionStep {
  final int number;
  final String step;

  InstructionStep({
    required this.number,
    required this.step,
  });

  factory InstructionStep.fromJson(Map<String, dynamic> json) {
    return InstructionStep(
      number: json['number'] ?? 0,
      step: json['step'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'step': step,
    };
  }
}