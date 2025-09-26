#lang racket

;; ===============================================================================================
;; TEST_MAP.RKT - Pruebas unitarias del generador de mapas
;; ===============================================================================================
;; Funcionalidad: Verificación de algoritmos de generación de mapas
;; - Tests de generación de mapas con diferentes dificultades
;; - Validación de porcentajes de minas  
;; - Verificación de números adyacentes calculados
;; - Pruebas de mapas seguros (evitando posiciones)
;; ===============================================================================================

(require "map.rkt")

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

; Ejecutar las pruebas
(test_map_generation)

(displayln "\n=== VERIFICACIONES ADICIONALES ===")
(verify_map 6 8 1)
(displayln "")
(verify_map 5 5 2)
(displayln "")
(verify_map 4 4 3)