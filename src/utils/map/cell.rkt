#lang racket

;; ===============================================================================================
;; CELL.RKT - Utilidades funcionales para manipulación y consulta de celdas del tablero
;; ===============================================================================================
;; Funcionalidad: Proporciona funciones puras para consultar y calcular valores de celdas
;; - Obtener valor de una celda
;; - Verificar si una celda es mina
;; - Contar minas adyacentes
;; - Llenar celdas con números adyacentes
;; ===============================================================================================

(provide fill_all_numbers)

(require "matrix.rkt")

;; Obtiene el valor en una posición específica de la matriz
(define (get_value_at matrix row col)
  (cond
    [(or (< row 0) (< col 0)) #f]
    [(>= row (length matrix)) #f]
    [(>= col (length (car matrix))) #f]
    [else (list-ref (list-ref matrix row) col)]))

;; Verifica si hay una mina en una posición
(define (is_mine? matrix row col)
  (equal? (get_value_at matrix row col) 'X))

;; Cuenta las minas adyacentes en las 8 direcciones
(define (count_adjacent_mines matrix row col)
  (define (count_mines_aux directions count)
    (cond
      [(null? directions) count]
      [else
       (count_mines_aux (cdr directions)
                        (+ count (if (is_mine? matrix
                                               (+ row (caar directions))
                                               (+ col (cadar directions))) 1 0)))]))
  (count_mines_aux '((-1 -1) (-1 0) (-1 1)
                     (0 -1)         (0 1)
                     (1 -1) (1 0) (1 1)) 0))

;; Llena una celda con el número correcto de minas adyacentes
(define (fill_cell_number matrix row col)
  (cond
    [(is_mine? matrix row col) matrix]
    [else
     (cond
       [(equal? (count_adjacent_mines matrix row col) 0) matrix]
       [else (replace-in-matrix matrix row col (count_adjacent_mines matrix row col))])]))

;; Recorre toda la matriz y llena los números adyacentes
(define (fill_all_numbers matrix)
  (define (fill_row matrix current_row current_col rows cols)
    (cond
      [(>= current_row rows) matrix]
      [(>= current_col cols)
       (fill_row matrix (+ current_row 1) 0 rows cols)]
      [else
       (fill_row (fill_cell_number matrix current_row current_col)
                 current_row (+ current_col 1) rows cols)]))
  (fill_row matrix 0 0 (length matrix) (if (null? matrix) 0 (length (car matrix)))))