#lang racket
;; app.rkt — entry point for UI, wires window and display together

(provide start-ui)

(require "window.rkt"
         "display.rkt")

(define (start-ui)
  ;; Create the main window
  (define win (make-main-window "Minesweeper"))

  ;; Attach display (board) to window
  (make-display win)

  ;; Show window
  (send win show #t))
