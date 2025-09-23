#lang racket/gui
;; window.rkt — defines the main window

(provide make-main-window)

(define (make-main-window title)
  ;; Create a new window (frame)
  (new frame%
       [label title]
       [width 400]
       [height 400]))
