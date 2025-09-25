#lang racket
(provide start-ui)

(require "window.rkt"
         "display.rkt")

(define (start-ui)
  (define window (make-window "MineCEeper"))

  ; mostrar la pantalla de menú en vez de juego directamente
  (draw-matrix window)

  (send window show #t))
