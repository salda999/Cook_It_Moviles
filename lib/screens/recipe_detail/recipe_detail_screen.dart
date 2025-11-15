import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/recipe.dart';
import '../../theme/app_theme.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final isExpanded = _scrollController.offset < 200;
      if (isExpanded != _isAppBarExpanded) {
        setState(() {
          _isAppBarExpanded = isExpanded;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                title: _isAppBarExpanded
                    ? null
                    : Text(
                        widget.recipe.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Imagen de la receta
                    widget.recipe.image != null
                        ? Image.network(
                            widget.recipe.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.primaryColor,
                                child: const Center(
                                  child: Icon(
                                    Icons.restaurant_menu,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: AppTheme.primaryColor,
                            child: const Center(
                              child: Icon(
                                Icons.restaurant_menu,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                    
                    // Gradiente overlay
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black26,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: _shareRecipe,
                  tooltip: 'Compartir receta',
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Próximamente: Agregar a favoritos'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                  tooltip: 'Agregar a favoritos',
                ),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            // Información básica
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    widget.recipe.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Información básica
                  Row(
                    children: [
                      if (widget.recipe.category != null) ...[
                        _InfoChip(
                          icon: Icons.category,
                          label: widget.recipe.category!,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (widget.recipe.area != null)
                        _InfoChip(
                          icon: Icons.public,
                          label: widget.recipe.area!,
                          color: AppTheme.accentColor,
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tags
                  if (widget.recipe.tagsList.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.recipe.tagsList.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Estadísticas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        icon: Icons.kitchen,
                        value: '${widget.recipe.ingredients.length}',
                        label: 'Ingredientes',
                      ),
                      _StatItem(
                        icon: Icons.list,
                        value: '${widget.recipe.displayInstructionSteps.length}',
                        label: 'Pasos',
                      ),
                      _StatItem(
                        icon: Icons.restaurant,
                        value: widget.recipe.area ?? 'N/A',
                        label: 'Origen',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Tabs
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: AppTheme.textSecondaryColor,
                indicatorColor: AppTheme.primaryColor,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.kitchen),
                    text: 'Ingredientes',
                  ),
                  Tab(
                    icon: Icon(Icons.format_list_numbered),
                    text: 'Instrucciones',
                  ),
                ],
              ),
            ),
            
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildIngredientsTab(),
                  _buildInstructionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsTab() {
    // Usar displayIngredients que devuelve ingredientes traducidos si están disponibles
    final ingredients = widget.recipe.displayIngredients;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              ingredient.displayName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: ingredient.displayMeasure.isNotEmpty
                ? Text(
                    ingredient.displayMeasure,
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                    ),
                  )
                : null,
            trailing: IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () => _copyToClipboard(ingredient.displayString),
              tooltip: 'Copiar',
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstructionsTab() {
    final steps = widget.recipe.displayInstructionSteps;
    
    if (steps.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.description,
                size: 64,
                color: AppTheme.textSecondaryColor,
              ),
              SizedBox(height: 16),
              Text(
                'Instrucciones no disponibles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    step,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _shareRecipe() {
    final text = '''
🍽️ ${widget.recipe.name}

📍 Origen: ${widget.recipe.area ?? 'No especificado'}
🏷️ Categoría: ${widget.recipe.category ?? 'No especificado'}

👨‍🍳 Ingredientes (${widget.recipe.ingredients.length}):
${widget.recipe.ingredients.map((i) => '• ${i.toString()}').join('\n')}

📱 Descubre más recetas con Cook It!
''';

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receta copiada al portapapeles'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copiado: $text'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 24,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}