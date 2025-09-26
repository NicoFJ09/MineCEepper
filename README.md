# MineCEepper

MineCEepper es una implementación funcional del clásico Buscaminas en Racket. El proyecto separa claramente la lógica del juego (core), la interfaz gráfica (UI) y la integración de estado, siguiendo principios de programación funcional pura en el núcleo del juego.

## Estructura principal

- `src/core/` — Lógica funcional pura para generación de mapas, conteo de minas y utilidades del tablero.
- `src/utils/` — Integración entre la lógica pura y el estado mutable necesario para la UI.
- `src/ui/` — Interfaz gráfica, pantallas y controladores de eventos.
- `assets/` — Imágenes y recursos visuales.

## Ejecución

Para iniciar el juego:

```sh
racket src/main.rkt
```