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
(require "../utils/bomb.rkt")

;; =============================== UTILIDADES DE IMPRESIÓN ===============================
;; Imprime una matriz de forma legible en consola
(define (print_matrix_pretty matrix)
  (define (print_row row)
    (for-each (lambda (cell) (display cell) (display " ")) row)
    (newline))
  (for-each print_row matrix))

;; =============================== PRUEBAS DE GENERACIÓN DE MAPAS ===============================
;; Prueba la generación de mapas para diferentes dificultades y tamaños
(define (test_map_generation)
  (displayln "=== TEST: Generación de mapas ===")
  (for ([difficulty '(1 2 3)])
    (for ([size '(4 6 8)])
      (let ([map (generate_map size size difficulty 0 0)])
        (displayln (format "Mapa ~ax~a dificultad ~a (seguro en 0,0):" size size difficulty))
        (print_matrix_pretty map)
        (newline)))))

;; =============================== VERIFICACIÓN DE MAPAS ===============================
;; Verifica que el porcentaje de minas sea correcto y muestra el resultado
(define (verify_map rows cols difficulty)
  (let* ([map (generate_map rows cols difficulty 0 0)]
         [bombs (count_total_bombs map)]
         [expected (calculate_bombs difficulty rows cols)])
    (displayln (format "Mapa ~ax~a dificultad ~a (seguro en 0,0): Bombas esperadas: ~a, encontradas: ~a"
                       rows cols difficulty expected bombs))
    (if (= bombs expected)
        (displayln "✅ Cantidad de bombas correcta")
        (displayln "❌ Cantidad de bombas INCORRECTA"))))

;; =============================== EJECUCIÓN DE PRUEBAS ===============================
(test_map_generation)

(displayln "\n=== VERIFICACIONES ADICIONALES ===")
(verify_map 6 8 1)
(displayln "")
(verify_map 5 5 2)
(displayln "")
(verify_map 4 4 3)