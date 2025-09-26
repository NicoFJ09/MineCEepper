#lang racket/gui

;; ===============================================================================================
;; EVENTS.RKT - Lógica principal de juego y reglas
;; ===============================================================================================
;; Funcionalidad:
;; - Verificación de victoria
;; - Revelación en cascada (áreas vacías)
;; - Revelar todas las minas
;; - Actualización visual de celdas
;; ===============================================================================================

(provide check-victory!
         count-revealed-safe-cells
         reveal-empty-area
         reveal-all-mines
         update-cell-visual)

(require "cell-status.rkt" 
         "../../utils/state.rkt"
         "../../utils/map/bomb.rkt") 


;; Verificar si el jugador ha ganado (todas las celdas no-mina reveladas)
(define (check-victory! game-map get-game-config cancel-global-timer! set-game-timer! get-screen set-screen)
  (define config (get-game-config))
  (define rows (game-vars-rows config))
  (define cols (game-vars-cols config))
  (define total-cells (* rows cols))
  (define total-mines (count_total_bombs game-map))
  (define safe-cells (- total-cells total-mines))
  (define revealed-safe-cells (count-revealed-safe-cells game-map get-game-config))
  (printf "VICTORIA: ~a/~a celdas seguras reveladas~n" revealed-safe-cells safe-cells)
  (when (= revealed-safe-cells safe-cells)
    (printf "¡VICTORIA! Todas las celdas seguras reveladas~n")
    (cancel-global-timer!)
    (define timer (new timer% 
                    [notify-callback (lambda ()
                                      (printf "TIMER: Ejecutando cambio a win~n")
                                      (when (not (eq? (get-screen) 'win))
                                        (set-screen 'win)))]
                      [interval 500]
                      [just-once? #t]))
    (set-game-timer! timer)
    (send timer start)))

;; Contar celdas reveladas que no son minas
(define (count-revealed-safe-cells game-map get-game-config)
  (define config (get-game-config))
  (define rows (game-vars-rows config))
  (define cols (game-vars-cols config))
  (define (count-row row-idx col-idx acc)
    (cond
      [(>= row-idx rows) acc]
      [(>= col-idx cols) (count-row (+ row-idx 1) 0 acc)]
      [else
       (define cell-value (list-ref (list-ref game-map row-idx) col-idx))
       (define is-revealed (get-cell-revealed row-idx col-idx))
       (define new-acc (if (and is-revealed (not (equal? cell-value 'X)))
                           (+ acc 1)
                           acc))
       (count-row row-idx (+ col-idx 1) new-acc)]))
  (count-row 0 0 0))

;; Revelar área vacía recursivamente (algoritmo de flood-fill)
(define (reveal-empty-area start-row start-col game-map get-game-config reveal-cell)
  (define config (get-game-config))
  (define rows (game-vars-rows config))
  (define cols (game-vars-cols config))
  (define (flood-reveal row col)
    (cond
      [(or (< row 0) (>= row rows) (< col 0) (>= col cols)) (void)]
      [(or (get-cell-revealed row col) (get-cell-flagged row col)) (void)]
      [else
       (define cell-value (list-ref (list-ref game-map row) col))
       (reveal-cell row col cell-value)
       (when (equal? cell-value 0)
         (flood-reveal (- row 1) (- col 1))
         (flood-reveal (- row 1) col)
         (flood-reveal (- row 1) (+ col 1))
         (flood-reveal row (- col 1))
         (flood-reveal row (+ col 1))
         (flood-reveal (+ row 1) (- col 1))
         (flood-reveal (+ row 1) col)
         (flood-reveal (+ row 1) (+ col 1)))]))
  (flood-reveal start-row start-col))

;; Revelar TODAS las minas (cuando pierdes)
(define (reveal-all-mines game-map reveal-cell set-cell-flagged)
  (define rows (length game-map))
  (define cols (length (car game-map)))
  (printf "MINES: Revelando todas las minas...~n")
  (for ([row rows])
    (for ([col cols])
      (define cell-value (list-ref (list-ref game-map row) col))
      (when (equal? cell-value 'X)
        (printf "MINES: Revelando mina en [~a,~a]~n" row col)
        (set-cell-flagged row col #f)
        (reveal-cell row col cell-value)))))

;; Actualizar visual de una celda
(define (update-cell-visual row col game-map get-cell-asset-path update-button-image)
  (define cell-value (list-ref (list-ref game-map row) col))
  (define is-revealed (get-cell-revealed row col))
  (define is-flagged (get-cell-flagged row col))
  (define asset-path (get-cell-asset-path cell-value is-revealed is-flagged))
  (update-button-image row col asset-path))