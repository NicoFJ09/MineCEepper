#lang racket

;; ===============================================================================================
;; GAME-INTEGRATION.RKT - Integración entre lógica pura y estado del juego
;; ===============================================================================================
;; Funcionalidad: Conecta la lógica funcional pura del core con el estado mutable de la UI
;; - Funciones puras para crear mapas sin efectos secundarios
;; - Funciones de interfaz que modifican estado global
;; - Mapeo entre valores del juego y assets visuales
;; - Conversión entre formatos de dificultad
;; ===============================================================================================

(provide generate-game-map
         create-game-map
         get-cell-asset-path
         difficulty-to-number
         number-to-difficulty)

(require "../state.rkt"
         "../../core/map.rkt")

;; Convierte nombres de dificultad a números
(define (difficulty-to-number difficulty)
  (cond
    [(equal? difficulty 'easy) 1]    ; 10% minas
    [(equal? difficulty 'medium) 2]  ; 15% minas  
    [(equal? difficulty 'hard) 3]    ; 20% minas
    [else 1]))

;; Convierte números a nombres de dificultad  
(define (number-to-difficulty num)
  (cond
    [(equal? num 1) 'easy]
    [(equal? num 2) 'medium]
    [(equal? num 3) 'hard]
    [else 'easy]))

;; ================= FUNCIONES DE CREACIÓN =================

;; Generar mapa seguro basado en configuración
(define (create-game-map config first-row first-col)
  (define rows (game-vars-rows config))
  (define cols (game-vars-cols config))
  (define raw-difficulty (game-vars-difficulty config))
  (printf "DEBUG SAFE: raw-difficulty = ~a (es número? ~a)~n" raw-difficulty (number? raw-difficulty))
  (define difficulty (if (number? raw-difficulty)
                        raw-difficulty  
                        (difficulty-to-number raw-difficulty))) 
  (printf "DEBUG SAFE: difficulty final = ~a~n" difficulty)
  (generate_map rows cols difficulty first-row first-col))

;; ================= FUNCIONES DE INTERFAZ =================

;; Genera un mapa seguro evitando una posición específica (primer click)
(define (generate-game-map first-row first-col)
  (define config (get-game-config))
  (define new-map (create-game-map config first-row first-col))
  (set-game-map! new-map)
  new-map)

;; Mapea el contenido de una celda al asset correspondiente
(define (get-cell-asset-path cell-value is-revealed? is-flagged?)
  (cond
    [is-flagged? "./assets/tiles/flag.png"]           ; Bandera
    [(not is-revealed?) "./assets/tiles/tile.png"]      ; Celda oculta
    [(equal? cell-value 'X) "./assets/tiles/mine.png"] ; Mina revelada
    [(equal? cell-value 0) "./assets/tiles/zeros.png"] ; Celda vacía 
    [(and (number? cell-value) (> cell-value 0))       ; Números 1-8
     (string-append "./assets/tiles/number" (number->string cell-value) ".png")]
    [else "./assets/tiles/tile.png"]))                  ; Fallback