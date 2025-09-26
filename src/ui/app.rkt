#lang racket

;; ===============================================================================================
;; APP.RKT - Controlador principal de la aplicación UI
;; ===============================================================================================
;; Funcionalidad: Inicializa y coordina la interfaz gráfica del juego
;; - Crea la ventana principal del juego
;; - Registra callbacks para cambios de pantalla
;; - Coordina la visualización y navegación
;; ===============================================================================================

(provide start-ui)
(require "window.rkt" "display.rkt" "../utils/state.rkt" racket/gui)

(define main-window #f)

(define (refresh-ui)
  (when main-window
    (display-screen main-window)))

(define (start-ui)
  (set! main-window (make-window "MineCEeper"))
  (register-on-screen-change! refresh-ui)
  (display-screen main-window)
  (send main-window show #t)
  main-window)