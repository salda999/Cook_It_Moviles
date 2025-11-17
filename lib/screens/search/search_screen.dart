import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_constants.dart';
import '../recipes/recipes_list_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialCategory;
  final bool isRandomRecipe;

  const SearchScreen({
    super.key,
    this.initialCategory,
    this.isRandomRecipe = false,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedCategory;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    
    if (widget.isRandomRecipe) {
      _showRandomRecipeMessage();
    }
  }

  void _showRandomRecipeMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎲 ¡Preparando una receta sorpresa para ti!'),
          backgroundColor: AppTheme.accentColor,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isRandomRecipe 
            ? 'Receta Aleatoria' 
            : selectedCategory != null 
              ? _getCategoryDisplayName(selectedCategory!)
              : 'Buscar Recetas',
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header con barra de búsqueda
          Container(
            color: AppTheme.primaryColor,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              children: [
                // Barra de búsqueda
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: widget.isRandomRecipe 
                        ? 'Generando receta aleatoria...'
                        : 'Buscar por nombre de receta (en inglés)...',
                      prefixIcon: Icon(
                        widget.isRandomRecipe ? Icons.shuffle : Icons.search,
                        color: AppTheme.textSecondaryColor,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    enabled: !widget.isRandomRecipe,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                
                if (!widget.isRandomRecipe) ...[
                  const SizedBox(height: 15),
                  
                  // Botón de búsqueda
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _performSearch,
                      icon: isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.search),
                      label: Text(
                        isLoading ? 'Buscando...' : 'Buscar Recetas',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Contenido principal
          Expanded(
            child: widget.isRandomRecipe 
              ? _buildRandomRecipeContent()
              : _buildSearchContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedCategory != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.category,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Categoría: ${_getCategoryDisplayName(selectedCategory!)}',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = null;
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          
          // Instrucciones
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.blue.shade200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Cómo buscar recetas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '• Busca por nombre de receta en inglés: "pasta", "chicken", "chocolate"\n• Ejemplos: "lasagna", "tiramisu", "paella", "carbonara"\n• Usa nombres específicos: "beef stew", "apple pie", "fish tacos"\n• También funciona con nombres parciales: "chick" encontrará recetas con "chicken"',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Nota importante sobre el idioma
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.orange.shade200,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.language,
                  color: Colors.orange.shade600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Importante',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'La búsqueda debe hacerse en inglés, pero los ingredientes e instrucciones de las recetas se traducen automáticamente al español.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Próximamente
          const Text(
            'Los resultados aparecerán aquí',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          
          const SizedBox(height: 10),
          
          const Text(
            'Aquí podrás ver todas las recetas que coincidan con tu búsqueda.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRandomRecipeContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.shuffle,
                size: 60,
                color: AppTheme.accentColor,
              ),
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              '🎲 ¡Receta Sorpresa!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Estamos preparando una receta aleatoria especial para ti. Una vez que conectemos con la API, aquí aparecerá una deliciosa sorpresa.',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎲 ¡Generando nueva receta sorpresa!'),
                    backgroundColor: AppTheme.accentColor,
                  ),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Otra receta sorpresa'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch() async {
    if (_searchController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, escribe algo para buscar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Navegar a la pantalla de resultados
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipesListScreen(
          title: 'Resultados: "${_searchController.text}"',
          searchQuery: _searchController.text.trim(),
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case RecipeCategories.dessert:
        return 'Postres';
      case RecipeCategories.chicken:
        return 'Pollo';
      case RecipeCategories.beef:
        return 'Carne';
      case RecipeCategories.seafood:
        return 'Mariscos';
      case RecipeCategories.pasta:
        return 'Pasta';
      case RecipeCategories.vegetarian:
        return 'Vegetariano';
      case RecipeCategories.breakfast:
        return 'Desayuno';
      default:
        return category;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}