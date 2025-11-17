# Cook It Backend

Backend API para la aplicación Cook It con autenticación JWT.

## 🚀 Instalación

1. Navegar al directorio del backend:
```bash
cd backend
```

2. Instalar dependencias:
```bash
npm install
```

3. Iniciar el servidor:
```bash
# Desarrollo (con nodemon)
npm run dev

# Producción
npm start
```

## 📚 API Endpoints

### Autenticación

#### Registro de usuario
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "usuario@ejemplo.com",
  "password": "MiPassword123",
  "confirmPassword": "MiPassword123"
}
```

#### Inicio de sesión
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "usuario@ejemplo.com",
  "password": "MiPassword123"
}
```

#### Obtener información del usuario
```http
GET /api/auth/me
Authorization: Bearer JWT_TOKEN
```

#### Verificar token
```http
POST /api/auth/verify-token
Authorization: Bearer JWT_TOKEN
```

## 🔒 Seguridad

- Contraseñas hasheadas con bcrypt (12 rounds)
- Tokens JWT con expiración configurable
- Validación de entrada con express-validator
- Headers de seguridad con helmet
- CORS configurado

## 🗄️ Base de datos

- SQLite para simplicidad
- Tabla `users` con campos: id, email, password, created_at, updated_at

## ⚙️ Variables de entorno

Crear archivo `.env` con:
```
PORT=3000
JWT_SECRET=tu_clave_secreta_muy_segura
JWT_EXPIRES_IN=7d
NODE_ENV=development
DB_PATH=./database/cook_it.db
```