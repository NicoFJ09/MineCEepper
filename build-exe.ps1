# Script para generar el ejecutable de MineCEepper
# Uso: powershell -ExecutionPolicy Bypass -File .\build-exe.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Generador de Ejecutable MineCEepper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Generar el ejecutable
Write-Host "[1/4] Generando ejecutable..." -ForegroundColor Yellow
raco exe -o MineCEepper.exe src\main.rkt

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al generar el ejecutable" -ForegroundColor Red
    exit 1
}
Write-Host "Ejecutable generado correctamente" -ForegroundColor Green
Write-Host ""

# Paso 2: Crear paquete distribuible
Write-Host "[2/4] Creando paquete distribuible..." -ForegroundColor Yellow
raco distribute MineCEepper-dist MineCEepper.exe

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al crear el paquete distribuible" -ForegroundColor Red
    exit 1
}
Write-Host "Paquete distribuible creado correctamente" -ForegroundColor Green
Write-Host ""

# Paso 3: Copiar assets
Write-Host "[3/4] Copiando assets..." -ForegroundColor Yellow
Copy-Item -Path ".\assets" -Destination ".\MineCEepper-dist\" -Recurse -Force
Write-Host "Assets copiados correctamente" -ForegroundColor Green
Write-Host ""

# Paso 4: Verificar
Write-Host "[4/4] Verificando archivos..." -ForegroundColor Yellow
$exeExists = Test-Path ".\MineCEepper-dist\MineCEepper.exe"
$assetsExist = Test-Path ".\MineCEepper-dist\assets"

if ($exeExists -and $assetsExist) {
    Write-Host "Verificacion exitosa" -ForegroundColor Green
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Ejecutable generado exitosamente!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Ubicacion: .\MineCEepper-dist\MineCEepper.exe" -ForegroundColor White
    Write-Host ""
    Write-Host "Para distribuir:" -ForegroundColor Yellow
    Write-Host "  1. Comprime la carpeta MineCEepper-dist" -ForegroundColor White
    Write-Host "  2. Comparte el archivo ZIP" -ForegroundColor White
    Write-Host "  3. Los usuarios pueden ejecutar MineCEepper.exe directamente" -ForegroundColor White
    Write-Host ""
}
else {
    Write-Host "Error en la verificacion" -ForegroundColor Red
    if (-not $exeExists) { 
        Write-Host "  - No se encontro el ejecutable" -ForegroundColor Red 
    }
    if (-not $assetsExist) { 
        Write-Host "  - No se encontraron los assets" -ForegroundColor Red 
    }
    exit 1
}
