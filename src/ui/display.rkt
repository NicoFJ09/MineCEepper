#lang racket/gui
;; display.rkt — responsible for drawing/rendering area

(provide make-display)

(define (make-display parent)
  ;; Create a canvas inside the parent window (for board drawing)
  (new canvas%
       [parent parent]
       [paint-callback
        (lambda (canvas dc)
          ;; For now, just draw a placeholder
          (send dc draw-text "Minesweeper Board" 20 20))]))
