# Cómo Generar el Ejecutable de MineCEepper

## Requisitos Previos
- Racket instalado en el sistema
- PowerShell (Windows)

## Generación Automática

Ejecuta el script de construcción:

```powershell
.\build-exe.ps1
```

Este script:
1. Genera el ejecutable desde `src\main.rkt`
2. Crea un paquete distribuible con todas las dependencias
3. Copia los assets necesarios
4. Verifica que todo esté correcto

## Generación Manual

Si prefieres hacerlo manualmente:

### 1. Generar el ejecutable
```powershell
raco exe -o MineCEepper.exe src\main.rkt
```

### 2. Crear paquete distribuible
```powershell
raco distribute MineCEepper-dist MineCEepper.exe
```

### 3. Copiar assets
```powershell
Copy-Item -Path ".\assets" -Destination ".\MineCEepper-dist\" -Recurse -Force
```

## Estructura del Paquete Distribuible

```
MineCEepper-dist/
├── MineCEepper.exe          # Ejecutable principal
├── assets/                  # Recursos visuales
│   ├── tiles/              # Imágenes de celdas
│   └── backgrounds/        # Fondos
├── lib/                    # Bibliotecas de Racket
└── [DLLs de Racket]        # Dependencias del runtime
```

## Distribución

Para compartir el juego:

1. **Comprimir la carpeta completa**:
   ```powershell
   Compress-Archive -Path .\MineCEepper-dist -DestinationPath MineCEepper.zip
   ```

2. **Compartir el archivo ZIP**

3. **Instrucciones para el usuario**:
   - Descomprimir el ZIP
   - Ejecutar `MineCEepper.exe`
   - No requiere instalar Racket

## Solución de Problemas

### Los assets no se cargan
- Asegúrate de que la carpeta `assets` esté en el mismo directorio que `MineCEepper.exe`
- Verifica que las imágenes en `assets/tiles/` existan:
  - tile.png
  - flag.png
  - mine.png
  - zeros.png
  - number1.png a number8.png

### El ejecutable no inicia
- Verifica que las DLLs de Racket estén en la carpeta
- Ejecuta desde PowerShell para ver mensajes de error:
  ```powershell
  .\MineCEepper-dist\MineCEepper.exe
  ```

### Error "file not found"
- El sistema de rutas ahora busca automáticamente desde la ubicación del ejecutable
- Si persiste, verifica que `assets` esté al mismo nivel que el .exe

## Tamaño del Ejecutable

- **MineCEepper.exe**: ~22 MB
- **Paquete completo**: ~35 MB (incluye runtime de Racket)
- **Con assets**: +archivos de imágenes

## Notas Técnicas

El código ha sido modificado para resolver rutas de assets de forma dinámica:
- Archivo modificado: `src/utils/game/interactions.rkt`
- Funciones añadidas:
  - `get-base-path`: Obtiene la ubicación del ejecutable
  - `resolve-asset-path`: Resuelve rutas relativas correctamente
  - `load-image`: Carga imágenes con manejo de errores

Esto permite que el ejecutable funcione sin importar desde dónde se ejecute, siempre que la carpeta `assets` esté presente.
