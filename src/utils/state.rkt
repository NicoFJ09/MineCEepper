; =============================== GAME VARIABLES ===============================

#lang racket
(provide initial-game-vars
         get-screen
         set-screen
         register-on-screen-change!)

;; Struct para variables iniciales/configuración del juego
(struct game-vars (rows cols difficulty) #:transparent)
(define initial-game-vars (game-vars 8 10 'easy))

;; Variable global mutable para la pantalla actual
(define current-screen (box 'start))

;; =============================== NAVIGATION HANDLING ===============================
;; Observer para cambio de pantalla
(define on-screen-change (box (lambda () (void))))

;; Permite registrar un callback que se llama tras cada cambio de pantalla
(define (register-on-screen-change! cb)
    (set-box! on-screen-change cb))

;; Getter y setter para la pantalla actual
(define (get-screen) (unbox current-screen))
(define (set-screen scr)
    (set-box! current-screen scr)
    ((unbox on-screen-change)))