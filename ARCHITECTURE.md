# Estructura del Proyecto Cook It

Este proyecto sigue una arquitectura limpia y escalable para una aplicación de recetario que consume APIs.

## Estructura de carpetas

```
lib/
├── constants/           # Constantes de la aplicación
│   └── app_constants.dart
├── models/             # Modelos de datos
│   ├── recipe.dart
│   └── models.dart    # Archivo barril
├── screens/           # Pantallas de la aplicación
│   ├── home/         # Pantalla principal
│   ├── recipes/      # Lista de recetas
│   ├── search/       # Búsqueda de recetas
│   ├── favorites/    # Recetas favoritas
│   └── recipe_detail/ # Detalle de receta
├── widgets/          # Widgets reutilizables
│   ├── common/       # Widgets comunes
│   ├── recipe_card/  # Tarjetas de recetas
│   └── navigation/   # Navegación
├── services/         # Servicios para APIs
├── theme/           # Temas y estilos
│   └── app_theme.dart
└── utils/           # Utilidades
```

## Próximos pasos

1. Implementar pantallas principales
2. Crear servicio para consumir APIs de recetas
3. Implementar widgets de recetas
4. Añadir navegación entre pantallas
5. Implementar funcionalidad de favoritos