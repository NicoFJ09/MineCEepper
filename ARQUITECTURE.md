# Functional Minesweeper in Racket — Architecture & Roadmap

## Project Philosophy
- 100% functional programming (no OOP, no mutation)
- Modular, extensible, and readable code
- All state is explicit and immutable
- UI, logic, and input are separated for clarity

## General Structure (Recommended)
- `src/core/` — Game logic, state, and functional helpers
- `src/ui/` — UI rendering and components
- `src/input/` — Input handling (mouse, keyboard)
- `src/assets/` — Asset loading (images, sounds)
- `src/patterns/` — Functional design patterns (optional)

## State Representation
- Use lists of key-value pairs for all state
- Example: `(list (cons 'lives 3) (cons 'score 0))`
- Access and update state only with pure functions

## Roadmap: Steps to Build Minesweeper

1. **Core Functional Utilities**
   - Implement `get` and `set` functions for key-value state
   - Example: `(get 'lives state)` and `(set 'lives 2 state)`

2. **Game State & Board Representation**
   - Define the board as a 2D list of tiles (each tile is a key-value map)
   - Define the overall game state (board, status, timer, etc.)

3. **Game Logic**
   - Functions to initialize the board, place mines, calculate numbers
   - Reveal logic (including flood fill for empty tiles)
   - Win/lose condition checks

4. **UI Layer**
   - Render the board and game state using Racket's GUI or drawing libraries
   - Stateless UI: always render from the current state
   - Overlay for win/lose, start screen, etc.

5. **Input Handling**
   - Map mouse/keyboard events to game actions
   - Update state in response to input (never mutate, always return new state)

6. **Assets**
   - Organize and load images, sounds, etc. as needed

7. **Patterns & Extensibility**
   - Add functional patterns (e.g., observer, reducer) if needed for clean code
   - Keep modules small and composable

## Best Practices
- Never mutate state; always return a new version
- Keep functions pure and composable
- Pass state explicitly; avoid globals
- Isolate side effects (UI, IO) from logic
- Document each module and function clearly

---

**Start small, test each part, and build up your functional Minesweeper step by step!**