#lang racket

(require "map.rkt")

; Ejecutar las pruebas
(test_map_generation)

(displayln "\n=== VERIFICACIONES ADICIONALES ===")
(verify_map 6 8 1)
(displayln "")
(verify_map 5 5 2)
(displayln "")
(verify_map 4 4 3)