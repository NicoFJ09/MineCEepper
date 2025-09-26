#lang racket

;; ===============================================================================================
;; STATE.RKT - Manejo de estado global del juego
;; ===============================================================================================
;; Funcionalidad: Gestiona variables globales del juego usando estado mutable
;; - Configuración del juego (filas, columnas, dificultad)
;; - Navegación entre pantallas (start, game, win, lose)
;; - Estado del primer click y timers globales
;; - Mapas generados y estado de partida
;; ===============================================================================================

(provide initial-game-vars
         get-screen
         set-screen
         register-on-screen-change!
         get-game-config
         set-game-config!
         get-game-map
         set-game-map!
         is-first-click?
         set-first-click!
         reset-game-state!
         set-game-timer!
         get-game-timer
         cancel-global-timer!
         game-vars
         game-vars-rows
         game-vars-cols
         game-vars-difficulty)

;; Struct para variables iniciales/configuración del juego
(struct game-vars (rows cols difficulty) #:transparent)
(define initial-game-vars (game-vars 8 8 1)) ; 1=fácil, 2=medio, 3=difícil - tablero 8x8

;; Variables globales del juego
(define current-screen (box 'start))
(define current-game-config (box initial-game-vars))
(define current-game-map (box '()))
(define first-click (box #t))  

;; =============================== NAVIGATION HANDLING ===============================
;; Observer para cambio de pantalla
(define on-screen-change (box (lambda () (void))))

;; Permite registrar un callback que se llama tras cada cambio de pantalla
(define (register-on-screen-change! cb)
    (set-box! on-screen-change cb))

;; Getter y setter para la pantalla actual
(define (get-screen) (unbox current-screen))
(define (set-screen scr)
    (printf "STATE: Cambiando pantalla de ~a a ~a~n" (unbox current-screen) scr)
    (set-box! current-screen scr)
    ((unbox on-screen-change)))

;; =============================== GAME STATE MANAGEMENT ===============================
;; Getters y setters para configuración del juego
(define (get-game-config) (unbox current-game-config))
(define (set-game-config! rows cols difficulty)
    (set-box! current-game-config (game-vars rows cols difficulty)))

;; Getters y setters para el mapa del juego  
(define (get-game-map) (unbox current-game-map))
(define (set-game-map! map)
    (set-box! current-game-map map))

;; =============================== FIRST CLICK MANAGEMENT ===============================
;; Manejo del primer click para generar mapa sin perder
(define (is-first-click?) (unbox first-click))
(define (set-first-click! value) (set-box! first-click value))

;; Variables para manejar timer global
(define game-timer-ref (box #f))

;; Funciones para manejar el timer global
(define (set-game-timer! timer) (set-box! game-timer-ref timer))
(define (get-game-timer) (unbox game-timer-ref))
(define (cancel-global-timer!)
  (define timer (get-game-timer))
  (when timer
    (printf "TIMER: Cancelando timer global~n")
    (send timer stop)
    (set-box! game-timer-ref #f)))

;; Reset completo del estado del juego
(define (reset-game-state!)
  (printf "RESET: Reseteando estado del juego...~n")
  ;; Cancelar cualquier timer activo
  (cancel-global-timer!)
  (set-box! first-click #t)
  (set-box! current-game-map '())
  (printf "RESET: Estado reseteado correctamente~n"))