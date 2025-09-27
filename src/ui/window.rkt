#lang racket/gui

;; ===============================================================================================
;; WINDOW.RKT - Configuración de la ventana principal
;; ===============================================================================================
;; Funcionalidad: Crea y configura la ventana base del juego
;; - Define propiedades de la ventana (título, tamaño, etc.)
;; - Maneja el cierre de la aplicación
;; ===============================================================================================

(provide make-window)

(define (make-window title)
  (new frame%
       [label title]
       [width 800]
       [height 600]))
