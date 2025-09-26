#lang racket
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