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

; Ejecutar las pruebas
(test_map_generation)

(displayln "\n=== VERIFICACIONES ADICIONALES ===")
(verify_map 6 8 1)
(displayln "")
(verify_map 5 5 2)
(displayln "")
(verify_map 4 4 3)