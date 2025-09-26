#lang racket/gui
(provide show-game-screen)
(require "../../utils/state.rkt")

(define (show-game-screen mainWindow)
  (define panel (new vertical-panel% [parent mainWindow]))
  (new message% [parent panel] [label "Pantalla de juego (GAME)"])

  (new button%
    [parent panel]
    [label "Ganar"]
    [callback (lambda (_btn _evt)
          (set-screen 'win))])
  (new button%
    [parent panel]
    [label "Perder"]
    [callback (lambda (_btn _evt)
          (set-screen 'lose))])
  panel)