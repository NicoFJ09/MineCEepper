#lang racket/gui
; window.rkt — defines the main window

(provide make-window)

(define (make-window title)
  (new frame%
       [label title]
       [width 300]
       [height 300]))
