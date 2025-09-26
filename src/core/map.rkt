#lang racket

;cantidad de minas por entrada
(define (cant_minas num)
  (cond
    ((equal? num 1)0.10)
    ((equal? num 2)0.15)
    ((equal? num 3)0.20)
    (else 0.10)))


(define (create_list num)
  (cond
    ((equal? num 0) '())
    (else (cons 0 (create_list (- num 1))))))

(define (empty_list num)
  (cond
    ((equal? num 0) '())
    (else (cons '() (create_list (- num 1))))))

(define (matrix rows columns)
  (cond
    ((equal? rows 0) '())
    (else (cons(create_list columns)(matrix (- rows 1)columns)))))


;se me pasa una matriz, si la dificultad es de 1 entonces tengo que usar un 10%,2 un 15 y 3 un 20
;ocupo una funcion que remplace cosas
;ocupo una funcion que ponga aleatoriamente esas bombas
;y una funcion que las ponga como tal


;remplaza por lista
(define (replace_at_index list i value)
  (cond
    ((null? list) '())
    ((equal? i 0) (cons value (cdr list)))
    (else (cons (car list) (replace_at_index (cdr list) (- i 1) value)))))

;remplazo en matrix
(define (replace_in_matrix matrix row col value)
  (cond
    ((null? matrix) '())
    ((equal? row 0)(cons (replace_at_index (car matrix) col value) (cdr matrix)))
    (else 
     (cons (car matrix) (replace_in_matrix (cdr matrix) (- row 1) col value)))))

;bombas, el floor es redondear hacia abajo y el inexact->exact es para poder pasar de un decimal a un numero exacto
(define (calculate_bombs dificultad rows cols)
  (inexact->exact (floor (* (* rows cols) (cant_minas dificultad)))))

;esta parte está dividida solo para referencia de hasta donde terminé de trabajar el lunes


;posiciones posibles 
(define (possible_positions rows cols)
  (define (row_pos row cols acc)
    (cond
      ((< cols 0) acc)
      (else (row_pos row (- cols 1) (cons (list row cols) acc)))))
  
  (define (all_rows rows cols acc)
    (cond
      ((< rows 0) acc)
      (else (all_rows (- rows 1) cols (append (row_pos rows (- cols 1) '()) acc)))))
  
  (all_rows (- rows 1) cols '()))

;random 
(define (shuffle list)
  (define (shuffle_aux input output)
    (cond
      ((null? input) output)
      (else
       (define len (length input))
       (define rand (random len))
       (define selected (list-ref input rand))
       (define remaining (append (take input rand) (drop input (+ rand 1))))
       (shuffle_aux remaining (cons selected output)))))
  (shuffle_aux list '()))

;remplazo por una bomba - la bomba es representada por una X 
(define (place_one_bomb matrix row col)
  (replace_in_matrix matrix row col 'X))

;se ponen las bombas en la matriz
(define (bomb_placement dificultad matrix)
  (define rows (length matrix))
  (define cols (if (null? matrix) 0 (length (car matrix))))
  (define num_bombs (calculate_bombs dificultad rows cols))
  
  ;solo se pueden poner en las posiciones que se deben
  (define all_pos (possible_positions rows cols))
  
  (define shuffled_pos (shuffle all_pos))
  
  ;Se usan solo las que se pueden
  (define bomb-positions (take shuffled_pos num_bombs))
  
  ;Ahora si pongo las bombas
  (define (place_all_bombs matrix positions)
    (cond
      ((null? positions) matrix)
      (else
       (define pos (car positions))
       (define new-matrix (place_one_bomb matrix (car pos) (cadr pos)))
       (place_all_bombs new-matrix (cdr positions)))))
  
  (place_all_bombs matrix bomb-positions))

;Para las pruebas se puede usar:

(define (print_ matrix)
  (cond
    ((null? matrix) (void))
    (else
     (displayln (car matrix))
     (print_ (cdr matrix)))))