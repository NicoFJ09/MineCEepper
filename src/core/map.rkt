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
(provide generate_complete_map
         generate_safe_map
         test_map_generation
         verify_map
         print_matrix_pretty
         count_total_bombs
         matrix
         bomb_placement)

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

;random - versión funcional pura
(define (shuffle list)
  (define (shuffle_aux input output)
    (cond
      ((null? input) output)
      (else
       ((lambda (rand_index)
         (shuffle_aux (append (take input rand_index) (drop input (+ rand_index 1)))
                     (cons (list-ref input rand_index) output)))
        (random (length input))))))
  (shuffle_aux list '()))

;remplazo por una bomba - la bomba es representada por una X 
(define (place_one_bomb matrix row col)
  (replace_in_matrix matrix row col 'X))

;se ponen las bombas en la matriz - versión funcional pura
(define (bomb_placement dificultad matrix)
  (define (place_all_bombs matrix positions)
    (cond
      ((null? positions) matrix)
      (else
       (place_all_bombs 
         (place_one_bomb matrix (caar positions) (cadar positions))
         (cdr positions)))))
  
  (place_all_bombs matrix 
    (take (shuffle (possible_positions (length matrix) 
                                      (if (null? matrix) 0 (length (car matrix)))))
          (calculate_bombs dificultad (length matrix) 
                          (if (null? matrix) 0 (length (car matrix)))))))

;Para las pruebas se puede usar:

(define (print_ matrix)
  (cond
    ((null? matrix) (void))
    (else
     (displayln (car matrix))
     (print_ (cdr matrix)))))

;=================== FUNCIONES PARA CALCULAR NÚMEROS ADYACENTES ===================

;Función para obtener el valor en una posición específica de la matriz
(define (get_value_at matrix row col)
  (cond
    ((or (< row 0) (< col 0)) #f)  
    ((>= row (length matrix)) #f)   
    ((>= col (length (car matrix))) #f)   
    (else (list-ref (list-ref matrix row) col))))

;Función para verificar si hay una mina en una posición
(define (is_mine? matrix row col)
  (equal? (get_value_at matrix row col) 'X))

;Función que cuenta las minas adyacentes en las 8 direcciones - funcional pura
(define (count_adjacent_mines matrix row col)
  (define (count_mines_aux directions count)
    (cond
      ((null? directions) count)
      (else
       (count_mines_aux (cdr directions) 
                       (+ count (if (is_mine? matrix 
                                             (+ row (caar directions)) 
                                             (+ col (cadar directions))) 1 0))))))
  
  (count_mines_aux '((-1 -1) (-1 0) (-1 1) (0 -1) (0 1) (1 -1) (1 0) (1 1)) 0))

;Función que llena una celda con el número correcto   
(define (fill_cell_number matrix row col)
  (cond
    ((is_mine? matrix row col) matrix)    
    (else
     (cond
       ((equal? (count_adjacent_mines matrix row col) 0) matrix)    
       (else (replace_in_matrix matrix row col (count_adjacent_mines matrix row col)))))))

;Función que recorre toda la matriz y llena los números   
(define (fill_all_numbers matrix)
  (define (fill_row matrix current_row current_col rows cols)
    (cond
      ((>= current_row rows) matrix)    
      ((>= current_col cols) 
       (fill_row matrix (+ current_row 1) 0 rows cols))   
      (else
       (fill_row (fill_cell_number matrix current_row current_col)
                 current_row (+ current_col 1) rows cols))))
  
  (fill_row matrix 0 0 (length matrix) (if (null? matrix) 0 (length (car matrix)))))

;Función principal que genera el mapa completo con minas y números - funcional pura
(define (generate_complete_map rows cols difficulty)
  (fill_all_numbers (bomb_placement difficulty (matrix rows cols))))

;=================== FUNCIONES DE TESTING ===================

;Función para imprimir matriz con formato más limpio
(define (print_matrix_pretty matrix)
  (define (print_row row)
    (cond
      ((null? row) (displayln ""))
      (else
       (display (if (equal? (car row) 'X) "* " 
                    (if (equal? (car row) 0) ". " 
                        (string-append (number->string (car row)) " "))))
       (print_row (cdr row)))))
  
  (define (print_all_rows matrix)
    (cond
      ((null? matrix) (void))
      (else
       (print_row (car matrix))
       (print_all_rows (cdr matrix)))))
  
  (displayln "========== MAPA GENERADO ==========")
  (print_all_rows matrix)
  (displayln "==================================="))

;Función de prueba simple - funcional pura
(define (test_map_generation)
  (displayln "Probando generación de mapa 8x10 dificultad fácil (1):")
  (print_matrix_pretty (generate_complete_map 8 10 1))
  
  (displayln "\nProbando generación de mapa 5x5 dificultad difícil (3):")
  (print_matrix_pretty (generate_complete_map 5 5 3)))

;Función para contar bombas en matriz (verificación)
(define (count_total_bombs matrix)
  (define (count_bombs_row row)
    (cond
      ((null? row) 0)
      ((equal? (car row) 'X) (+ 1 (count_bombs_row (cdr row))))
      (else (count_bombs_row (cdr row)))))
  
  (define (count_all_rows matrix)
    (cond
      ((null? matrix) 0)
      (else (+ (count_bombs_row (car matrix)) (count_all_rows (cdr matrix))))))
  
  (count_all_rows matrix))

;Función de verificación completa - funcional pura
(define (verify_map rows cols difficulty)
  (displayln (string-append "Mapa " (number->string rows) "x" (number->string cols) 
                           " - Dificultad: " (number->string difficulty)))
  (displayln (string-append "Celdas totales: " (number->string (* rows cols))))
  (displayln (string-append "Bombas esperadas: " (number->string (calculate_bombs difficulty rows cols))))
  (displayln (string-append "Bombas encontradas: " (number->string 
                           (count_total_bombs (generate_complete_map rows cols difficulty)))))
  (displayln (string-append "¿Correcto? " (if (equal? (calculate_bombs difficulty rows cols)
                                                      (count_total_bombs (generate_complete_map rows cols difficulty))) "SÍ" "NO")))
  (print_matrix_pretty (generate_complete_map rows cols difficulty)))

;=================== GENERACIÓN DE MAPA SEGURO (EVITANDO POSICIÓN) ===================

;Posiciones posibles excluyendo una posición específica y sus adyacentes
(define (safe_positions rows cols avoid_row avoid_col)
  (define (is_safe_position row col)
    ;; Evitar la posición clickeada y todas sus adyacentes
    (not (and (>= row (- avoid_row 1)) (<= row (+ avoid_row 1))
              (>= col (- avoid_col 1)) (<= col (+ avoid_col 1)))))
  
  (define (row_pos row cols acc)
    (cond
      ((< cols 0) acc)
      ((is_safe_position row cols) 
       (row_pos row (- cols 1) (cons (list row cols) acc)))
      (else (row_pos row (- cols 1) acc))))
  
  (define (all_rows rows cols acc)
    (cond
      ((< rows 0) acc)
      (else (all_rows (- rows 1) cols (append (row_pos rows (- cols 1) '()) acc)))))
  
  (all_rows (- rows 1) cols '()))

;Colocación de bombas evitando área segura
(define (safe_bomb_placement dificultad matrix avoid_row avoid_col)
  (define (place_all_bombs matrix positions)
    (cond
      ((null? positions) matrix)
      (else
       (place_all_bombs 
         (place_one_bomb matrix (caar positions) (cadar positions))
         (cdr positions)))))
  
  (define safe_positions_list (safe_positions (length matrix) 
                                            (if (null? matrix) 0 (length (car matrix)))
                                            avoid_row avoid_col))
  (define bombs_needed (calculate_bombs dificultad (length matrix) 
                                      (if (null? matrix) 0 (length (car matrix)))))
  
  (place_all_bombs matrix (take (shuffle safe_positions_list) bombs_needed)))

;Función principal para generar mapa seguro (evita mina en primera posición clickeada)
(define (generate_safe_map rows cols difficulty first_click_row first_click_col)
  (fill_all_numbers (safe_bomb_placement difficulty (matrix rows cols) first_click_row first_click_col)))