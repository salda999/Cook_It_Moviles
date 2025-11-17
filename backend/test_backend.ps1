# Script de prueba para el backend Cook It
Write-Host "🧪 Probando Backend Cook It..." -ForegroundColor Green

# 1. Probar endpoint principal
Write-Host "`n1. Probando endpoint principal..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:3000" -Method Get
    Write-Host "✅ Respuesta recibida:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 3
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. Probar health check
Write-Host "`n2. Probando health check..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:3000/health" -Method Get
    Write-Host "✅ Health check exitoso:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 3
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

# 3. Registrar usuario de prueba
Write-Host "`n3. Registrando usuario de prueba..." -ForegroundColor Yellow
$registerData = @{
    email = "test@cookitapp.com"
    password = "Test123456"
    confirmPassword = "Test123456"
} | ConvertTo-Json

try {
    $registerResponse = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/register" -Method Post -Body $registerData -ContentType "application/json"
    Write-Host "✅ Usuario registrado exitosamente:" -ForegroundColor Green
    $registerResponse | ConvertTo-Json -Depth 3
    
    # Guardar token para pruebas posteriores
    $token = $registerResponse.data.token
    
    # 4. Probar login con el usuario registrado
    Write-Host "`n4. Probando login..." -ForegroundColor Yellow
    $loginData = @{
        email = "test@cookitapp.com"
        password = "Test123456"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/login" -Method Post -Body $loginData -ContentType "application/json"
    Write-Host "✅ Login exitoso:" -ForegroundColor Green
    $loginResponse | ConvertTo-Json -Depth 3
    
    # 5. Probar endpoint protegido /me
    Write-Host "`n5. Probando endpoint protegido /me..." -ForegroundColor Yellow
    $headers = @{
        Authorization = "Bearer $token"
    }
    
    $meResponse = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/me" -Method Get -Headers $headers
    Write-Host "✅ Información del usuario obtenida:" -ForegroundColor Green
    $meResponse | ConvertTo-Json -Depth 3
    
    # 6. Verificar token
    Write-Host "`n6. Verificando token..." -ForegroundColor Yellow
    $verifyResponse = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/verify-token" -Method Post -Headers $headers
    Write-Host "✅ Token verificado:" -ForegroundColor Green
    $verifyResponse | ConvertTo-Json -Depth 3
    
} catch {
    Write-Host "❌ Error en el registro: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $responseStream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($responseStream)
        $responseBody = $reader.ReadToEnd()
        Write-Host "Detalles del error: $responseBody" -ForegroundColor Red
    }
}

Write-Host "`n🎉 Pruebas completadas!" -ForegroundColor Green