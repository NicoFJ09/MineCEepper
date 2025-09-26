#lang racket

;; ===============================================================================================
;; CELL-STATUS.RKT - Estado y utilidades para celdas del tablero
;; ===============================================================================================
;; Funcionalidad:
;; - Manejo de matrices de revelado y banderas (boxes)
;; - Consulta y modificación del estado de cada celda
;; ===============================================================================================

(provide revealed-cells
         flagged-cells
         get-cell-revealed
         get-cell-flagged
         set-cell-revealed
         set-cell-flagged
         toggle-flag
         set-cell-state)

;; Matrices de estado (boxes)
(define revealed-cells (box '()))
(define flagged-cells (box '()))

;; Consulta si una celda está revelada
(define (get-cell-revealed row col)
  (define revealed-matrix (unbox revealed-cells))
  (cond
    [(or (null? revealed-matrix) (>= row (length revealed-matrix))) #f]
    [(>= col (length (car revealed-matrix))) #f]
    [else (list-ref (list-ref revealed-matrix row) col)]))

;; Consulta si una celda tiene bandera
(define (get-cell-flagged row col)
  (define flagged-matrix (unbox flagged-cells))
  (cond
    [(or (null? flagged-matrix) (>= row (length flagged-matrix))) #f]
    [(>= col (length (car flagged-matrix))) #f]
    [else (list-ref (list-ref flagged-matrix row) col)]))

;; Marca una celda como revelada
(define (set-cell-revealed row col value)
  (set-cell-state revealed-cells row col value))

;; Marca una celda como bandera
(define (set-cell-flagged row col value)
  (set-cell-state flagged-cells row col value))

;; Alterna el estado de bandera de una celda
(define (toggle-flag row col)
  (define current-flag (get-cell-flagged row col))
  (set-cell-flagged row col (not current-flag)))

;; Modifica el valor de una celda en la matriz de estado indicada
(define (set-cell-state state-box row col value)
  (define matrix (unbox state-box))
  (define new-matrix 
    (for/list ([r (length matrix)])
      (cond
        [(= r row) 
         (for/list ([c (length (list-ref matrix r))])
           (if (= c col) value (list-ref (list-ref matrix r) c)))]
        [else (list-ref matrix r)])))
  (set-box! state-box new-matrix))