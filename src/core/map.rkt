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
(provide generate_map
         count_total_bombs)

;; -------------------------------------------------------------------------------
;; IMPORTS
;; -------------------------------------------------------------------------------
(require "../utils/matrix.rkt") ; Usado en: generate_map (para crear el tablero base)
(require "../utils/cell.rkt")   ; Usado en: generate_map (fill_all_numbers)
(require "../utils/bomb.rkt")   ; Usado en: generate_map (safe_bomb_placement)

;; -------------------------------------------------------------------------------
;; FUNCIONES DE UTILIDAD Y GENERACIÓN DE MAPA
;; -------------------------------------------------------------------------------

;Función para contar bombas en matriz (útil para lógica y pruebas)
(define (count_total_bombs matrix)
  (define (count_bombs_row row)
    (cond
      [(null? row) 0]
      [(equal? (car row) 'X) (+ 1 (count_bombs_row (cdr row)))]
      [else (count_bombs_row (cdr row))]))
  (define (count_all_rows matrix)
    (cond
      [(null? matrix) 0]
      [else (+ (count_bombs_row (car matrix)) (count_all_rows (cdr matrix)))]))
  (count_all_rows matrix))

;; -------------------------------------------------------------------------------
;; GENERACIÓN DE MAPA SEGURO (EVITANDO POSICIÓN)
;; -------------------------------------------------------------------------------

(define (generate_map rows cols difficulty first_click_row first_click_col)
  (fill_all_numbers (safe_bomb_placement difficulty (matrix rows cols) first_click_row first_click_col)))