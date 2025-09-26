#lang racket/gui

;; ===============================================================================================
;; INTERACTIONS.RKT - Manejo de interacción directa del usuario
;; ===============================================================================================
;; Funcionalidad:
;; - Callbacks de botones (click en celda, click en modo bandera)
;; - Alternar modo bandera
;; - Carga de imágenes
;; ===============================================================================================

(provide handle-cell-click
         handle-flag-click
         toggle-flag-mode
         load-image)

(require "cell-status.rkt")
(require "events.rkt")

;; Función para cargar imagen
(define (load-image path)
  (read-bitmap path))

;; Alternar modo bandera (solo por botón)
(define flag-mode (box #f)) ; Si prefieres, puedes mover esto a un módulo de estado general

(define (toggle-flag-mode)
  (define current-mode (unbox flag-mode))
  (set-box! flag-mode (not current-mode))
  (printf "Modo bandera: ~a~n" (if (not current-mode) "ACTIVADO" "DESACTIVADO")))

;; Manejar click izquierdo en celda
(define (handle-cell-click row col button
                           is-first-click? generate-game-map set-first-click!
                           get-game-map get-game-config get-screen set-screen
                           cancel-global-timer! set-game-timer!
                           reveal-cell update-button-image set-cell-flagged)
  (define is-flagged (get-cell-flagged row col))
  (define is-already-revealed (get-cell-revealed row col))
  (when (and (not is-flagged) (not is-already-revealed))
    (when (is-first-click?)
      (printf "PRIMER CLICK en [~a,~a] - Generando mapa seguro...~n" row col)
      (generate-game-map row col)
      (set-first-click! #f))
    (define game-map (get-game-map))
    (define cell-value (list-ref (list-ref game-map row) col))
    (printf "Click en celda [~a,~a] - Valor: ~a~n" row col cell-value)
    (cond
      [(equal? cell-value 'X)
       (printf "¡BOOM! Mina encontrada - Game Over~n")
       (reveal-cell row col cell-value)
       (reveal-all-mines game-map reveal-cell set-cell-flagged)
       (cancel-global-timer!)
       (define timer (new timer%
                          [notify-callback (lambda ()
                                             (printf "TIMER: Ejecutando cambio a lose~n")
                                             (when (not (eq? (get-screen) 'lose))
                                               (set-screen 'lose)))]
                          [interval 1000]
                          [just-once? #t]))
       (set-game-timer! timer)
       (send timer start)]
      [(equal? cell-value 0)
       (printf "Celda vacía - Revelando área...~n")
       (reveal-empty-area row col game-map get-game-config reveal-cell)
       (check-victory! game-map get-game-config cancel-global-timer! set-game-timer! get-screen set-screen)]
      [else
       (printf "Celda con número ~a~n" cell-value)
       (reveal-cell row col cell-value)
       (check-victory! game-map get-game-config cancel-global-timer! set-game-timer! get-screen set-screen)])))

;; Manejar click bandera
(define (handle-flag-click row col button update-button-image)
  (define is-flagged (get-cell-flagged row col))
  (define is-revealed (get-cell-revealed row col))
  (when (not is-revealed)
    (cond
      [is-flagged
       (printf "Quitando bandera de [~a,~a]~n" row col)
       (set-cell-flagged row col #f)
       (update-button-image row col "./assets/tiles/tile.png")]
      [else
       (printf "Poniendo bandera en [~a,~a]~n" row col)
       (set-cell-flagged row col #t)
       (update-button-image row col "./assets/tiles/flag.png")])))