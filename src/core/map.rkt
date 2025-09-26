#lang racket

;; ===============================================================================================
;; MAP.RKT - Motor de generación de mapas de buscaminas
;; ===============================================================================================
;; Funcionalidad: Genera matrices de juego con minas y números usando algoritmos funcionales puros
;; - Crea mapas aleatorios con porcentajes de minas según dificultad
;; - Genera mapas seguros evitando posiciones específicas (primer click)
;; - Calcula números adyacentes para cada celda
;; ===============================================================================================

; Exportar funciones principales
(provide generate_map)

;; -------------------------------------------------------------------------------
;; IMPORTS
;; -------------------------------------------------------------------------------
(require "../utils/game/matrix.rkt") ; Usado en: generate_map (para crear el tablero base)
(require "../utils/game/cell.rkt")   ; Usado en: generate_map (fill_all_numbers)
(require "../utils/game/bomb.rkt")   ; Usado en: generate_map (safe_bomb_placement)

;; -------------------------------------------------------------------------------
;; GENERACIÓN DE MAPA SEGURO (EVITANDO POSICIÓN SELECCIONADA)
;; -------------------------------------------------------------------------------

(define (generate_map rows cols difficulty first_click_row first_click_col)
  (fill_all_numbers (safe_bomb_placement difficulty (matrix rows cols) first_click_row first_click_col)))