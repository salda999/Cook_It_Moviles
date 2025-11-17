// Servidor de prueba simple
const express = require('express');
const app = express();
const PORT = 3001;

app.use(express.json());

// Endpoint de prueba
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Cook It Backend Test - funcionando correctamente',
    timestamp: new Date().toISOString()
  });
});

// Prueba de registro simple (sin base de datos)
app.post('/api/auth/register', (req, res) => {
  const { email, password, confirmPassword } = req.body;
  
  if (!email || !password || !confirmPassword) {
    return res.status(400).json({
      success: false,
      message: 'Todos los campos son requeridos'
    });
  }
  
  if (password !== confirmPassword) {
    return res.status(400).json({
      success: false,
      message: 'Las contraseñas no coinciden'
    });
  }
  
  res.status(201).json({
    success: true,
    message: 'Usuario registrado exitosamente (prueba)',
    data: {
      user: { id: 1, email: email },
      token: 'test_jwt_token_123'
    }
  });
});

app.listen(PORT, () => {
  console.log(`🧪 Servidor de prueba corriendo en http://localhost:${PORT}`);
});