#lang racket

;; ===============================================================================================
;; BOMB.RKT - Utilidades funcionales para manejo y colocación de bombas en el tablero
;; ===============================================================================================
;; Funcionalidad: Proporciona funciones para:
;; - Calcular la cantidad de bombas según la dificultad y tamaño del tablero
;; - Generar posiciones posibles para colocar bombas
;; - Barajar posiciones aleatoriamente (shuffle)
;; - Colocar bombas en la matriz
;; - Generar listas de posiciones seguras (para el primer click)
;; ===============================================================================================

(provide cant_minas
         calculate_bombs
         count_total_bombs
         possible_positions
         shuffle
         place_one_bomb
         bomb_placement
         safe_positions
         safe_bomb_placement)

(require "matrix.rkt")

;; Porcentaje de minas según dificultad
(define (cant_minas num)
  (cond
    [(equal? num 1) 0.10]
    [(equal? num 2) 0.15]
    [(equal? num 3) 0.20]
    [else 0.10]))

;; Calcula la cantidad de bombas a colocar
(define (calculate_bombs dificultad rows cols)
  (inexact->exact (floor (* (* rows cols) (cant_minas dificultad)))))

;; Genera todas las posiciones posibles del tablero
(define (possible_positions rows cols)
  (define (row_pos row cols acc)
    (cond
      [(< cols 0) acc]
      [else (row_pos row (- cols 1) (cons (list row cols) acc))]))
  (define (all_rows rows cols acc)
    (cond
      [(< rows 0) acc]
      [else (all_rows (- rows 1) cols (append (row_pos rows (- cols 1) '()) acc))]))
  (all_rows (- rows 1) cols '()))

;; Baraja una lista de posiciones (shuffle funcional)
(define (shuffle list)
  (define (shuffle_aux input output)
    (cond
      [(null? input) output]
      [else
       (let ([rand_index (random (length input))])
         (shuffle_aux (append (take input rand_index) (drop input (+ rand_index 1)))
                      (cons (list-ref input rand_index) output)))]))
  (shuffle_aux list '()))

;; Coloca una bomba en la posición dada
(define (place_one_bomb matrix row col)
  (replace-in-matrix matrix row col 'X))

;; Coloca todas las bombas en posiciones aleatorias
(define (bomb_placement dificultad matrix)
  (define (place_all_bombs matrix positions)
    (cond
      [(null? positions) matrix]
      [else
       (place_all_bombs 
         (place_one_bomb matrix (caar positions) (cadar positions))
         (cdr positions))]))
  (place_all_bombs matrix 
    (take (shuffle (possible_positions (length matrix) 
                                      (if (null? matrix) 0 (length (car matrix)))))
          (calculate_bombs dificultad (length matrix) 
                          (if (null? matrix) 0 (length (car matrix)))))))

;; Genera posiciones posibles excluyendo una posición y sus adyacentes
(define (safe_positions rows cols avoid_row avoid_col)
  (define (is_safe_position row col)
    (not (and (>= row (- avoid_row 1)) (<= row (+ avoid_row 1))
              (>= col (- avoid_col 1)) (<= col (+ avoid_col 1)))))
  (define (row_pos row cols acc)
    (cond
      [(< cols 0) acc]
      [(is_safe_position row cols) 
       (row_pos row (- cols 1) (cons (list row cols) acc))]
      [else (row_pos row (- cols 1) acc)]))
  (define (all_rows rows cols acc)
    (cond
      [(< rows 0) acc]
      [else (all_rows (- rows 1) cols (append (row_pos rows (- cols 1) '()) acc))]))
  (all_rows (- rows 1) cols '()))

;; Coloca bombas evitando el área segura (primer click)
(define (safe_bomb_placement dificultad matrix avoid_row avoid_col)
  (define (place_all_bombs matrix positions)
    (cond
      [(null? positions) matrix]
      [else
       (place_all_bombs 
         (place_one_bomb matrix (caar positions) (cadar positions))
         (cdr positions))]))
  (define safe_positions_list (safe_positions (length matrix) 
                                              (if (null? matrix) 0 (length (car matrix)))
                                              avoid_row avoid_col))
  (define bombs_needed (calculate_bombs dificultad (length matrix) 
                                        (if (null? matrix) 0 (length (car matrix)))))
  (place_all_bombs matrix (take (shuffle safe_positions_list) bombs_needed)))

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