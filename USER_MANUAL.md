# Manual de Usuario — MineCEepper

¡Bienvenido a MineCEepper!

MineCEepper es una versión funcional del clásico Buscaminas, diseñada para ser fácil de usar y entender. Aquí tienes todo lo que necesitas para empezar a jugar:

---

## ¿Cómo iniciar el juego?

1. **Requisitos:**
   - Tener instalado [Racket](https://racket-lang.org/).

2. **Ejecuta el juego:**
   - Abre una terminal en la carpeta del proyecto.
   - Escribe y ejecuta:
     ```sh
     racket src/main.rkt
     ```
   - Se abrirá la ventana principal del juego.

---

## ¿Cómo jugar?

### Pantalla de inicio
- Elige el tamaño del tablero (filas y columnas, entre 8 y 15).
- Selecciona la dificultad:
  - Fácil (10% minas)
  - Medio (15% minas)
  - Difícil (20% minas)
- Haz clic en "¡Iniciar Juego!" para comenzar.

### Pantalla de juego
- Verás una cuadrícula de celdas ocultas.
- **Click izquierdo:** Revela una celda.
  - Si es una mina, pierdes.
  - Si es un número, muestra cuántas minas hay alrededor.
  - Si es vacía, se revelan automáticamente las áreas vacías conectadas.
- **Modo bandera:**
  - Haz clic en "🚩 Modo Bandera" para activar/desactivar.
  - En modo bandera, el click pone o quita una bandera en la celda seleccionada (para marcar posibles minas).
- **Botones adicionales:**
  - "⟳ Nuevo Juego": Reinicia la partida con la configuración actual.
  - "Menú": Vuelve a la pantalla de inicio.

### Pantalla de fin
- Si revelas todas las celdas seguras (sin minas), ¡ganas!
- Si revelas una mina, pierdes.
- Puedes volver al inicio o jugar de nuevo.

---

## Reglas básicas
- El objetivo es revelar todas las celdas que no tienen minas.
- Usa las banderas para marcar las celdas donde crees que hay minas.
- El primer click siempre es seguro (no perderás en el primer intento).
- El número en una celda indica cuántas minas hay en las 8 celdas adyacentes.

---

## Consejos
- Piensa antes de revelar: usa los números para deducir dónde están las minas.
- Marca con banderas las minas para evitar errores.
- Puedes reiniciar el juego o cambiar la configuración en cualquier momento.

---

¡Diviértete jugando MineCEepper!
