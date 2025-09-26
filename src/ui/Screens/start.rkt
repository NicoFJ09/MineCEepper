#lang racket/gui
(provide show-start-screen)
(require "../../utils/state.rkt")

(define (show-start-screen mainWindow)
  (define panel (new vertical-panel% [parent mainWindow]))
  (new message% [parent panel] [label "Pantalla de inicio (START)"])
  (new button%
    [parent panel]
    [label "Ir a Juego"]
    [callback (lambda (_btn _evt)
          (set-screen 'game))])
  panel)