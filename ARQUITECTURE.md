# MineCEepper — Arquitectura

## Filosofía
- Núcleo 100% funcional (sin OOP, sin mutación en core)
- Código modular, extensible y legible
- Separación clara entre lógica, UI y estado

## Estructura real del proyecto

- `src/core/` — Lógica pura del juego (generación de mapas, conteo de minas, utilidades funcionales). Ejemplo: `map.rkt`.
- `src/utils/` — Integración entre lógica funcional y estado mutable para la UI. Ejemplo: `game-integration.rkt`, `state.rkt`.
- `src/ui/` — Interfaz gráfica, pantallas, controladores y eventos. Subcarpetas para pantallas y componentes.
- `assets/` — Imágenes y recursos visuales.

## Estado y flujo
- El core nunca muta estado ni accede a variables globales.
- La UI y la integración gestionan el estado y los efectos secundarios.
- El estado del juego se pasa explícitamente entre funciones.

## Módulos principales
- `map.rkt`: Generación y manipulación funcional de tableros.
- `game-integration.rkt`: Puente entre lógica pura y estado mutable.
- `app.rkt`, `window.rkt`, `display.rkt`: Controladores y renderizado de la UI.
- `Screens/`: Pantallas de inicio, juego y fin.

## Buenas prácticas
- Mantener la pureza funcional en el core.
- Aislar efectos secundarios en la UI y utilidades.
- Documentar cada módulo y función relevante.