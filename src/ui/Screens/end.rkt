#lang racket/gui
(provide show-end-screen)
(require "../../utils/state.rkt")

(define (show-end-screen mainWindow result)
  (define panel (new vertical-panel% [parent mainWindow]))
  (new message% [parent panel]
       [label (if (eq? result 'win)
                  "¡Ganaste!"
                  "Perdiste :(")])
  (new button%
       [parent panel]
       [label "Volver al inicio"]
       [callback (lambda (_btn _evt)
                   (set-screen 'start))])
  panel)