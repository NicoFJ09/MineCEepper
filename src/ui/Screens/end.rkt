#lang racket/gui

;; ===============================================================================================
;; END.RKT - Pantallas de fin de juego (victoria y derrota)
;; ===============================================================================================
;; Funcionalidad: Muestra resultados y opciones al finalizar partida
;; - Pantalla de victoria ("¡Ganaste!")
;; - Pantalla de derrota ("Perdiste :(")
;; - Botones para volver al inicio o jugar de nuevo
;; - Reset completo del estado del juego
;; ===============================================================================================

(provide show-end-screen)
(require "../../utils/state.rkt")

;; =============================== UI: PANTALLA DE FIN DE JUEGO ===============================
(define (show-end-screen mainWindow result)
  (define panel (new vertical-panel% [parent mainWindow]
                     [horiz-margin 2]
                     [alignment '(center center)]
                     [stretchable-height #t]))
  ;; Panel centrado y estirable para todo el contenido
  (define center-panel (new vertical-panel% [parent panel]
                            [alignment '(center center)]
                            [stretchable-height #t]
                            [stretchable-width #t]))
  ;; Espaciador flexible arriba
  (new vertical-panel% [parent center-panel]
                      [stretchable-height #t])
  ;; Mensaje justo encima de los botones, centrado
  (new message% [parent center-panel]
       [label (if (eq? result 'win)
                  "¡Ganaste! 🎉"
                  "Perdiste 😢")]
       [font (make-object font% 28 'default 'normal 'bold)])
  (define button-panel (new vertical-panel% [parent center-panel]
                           [alignment '(center center)]
                           [spacing 0]))
  (new button%
       [parent button-panel]
       [label "Volver al inicio"]
       [min-width 140]
       [callback (lambda (_btn _evt)
                   (reset-game-state!)
                   (set-screen 'start))])
  (new button%
       [parent button-panel]
       [label "Jugar de nuevo"]
       [min-width 140]
       [callback (lambda (_btn _evt)
                   (reset-game-state!)
                   (set-screen 'game))])
  ;; Espaciador flexible abajo
  (new vertical-panel% [parent center-panel]
                      [stretchable-height #t])
  panel)