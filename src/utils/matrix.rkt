#lang racket

;; ===============================================================================================
;; MATRIX.RKT - Utilidades funcionales para manipulación de listas y matrices
;; ===============================================================================================
;; Funcionalidad: Proporciona funciones puras para crear, modificar y consultar matrices y listas
;; - Creación de listas y matrices vacías
;; - Reemplazo de elementos en listas y matrices
;; ===============================================================================================

(provide matrix
         replace-in-matrix)

;; Crea una lista de ceros de longitud num
(define (create-list num)
  (cond
    [(zero? num) '()]
    [else (cons 0 (create-list (- num 1)))]))

;; Crea una lista de listas vacías de longitud num
(define (empty-list num)
  (cond
    [(zero? num) '()]
    [else (cons '() (create-list (- num 1)))]))

;; Crea una matriz de tamaño rows x columns llena de ceros
(define (matrix rows columns)
  (cond
    [(zero? rows) '()]
    [else (cons (create-list columns) (matrix (- rows 1) columns))]))

;; Reemplaza el elemento en la posición i de una lista por value
(define (replace-at-index list i value)
  (cond
    [(null? list) '()]
    [(zero? i) (cons value (cdr list))]
    [else (cons (car list) (replace-at-index (cdr list) (- i 1) value))]))

;; Reemplaza el elemento en la posición (row, col) de una matriz por value
(define (replace-in-matrix matrix row col value)
  (cond
    [(null? matrix) '()]
    [(zero? row) (cons (replace-at-index (car matrix) col value) (cdr matrix))]
    [else (cons (car matrix) (replace-in-matrix (cdr matrix) (- row 1) col value))]))