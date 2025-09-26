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
  (define panel (new vertical-panel% [parent mainWindow]))
  (new message% [parent panel]
       [label (if (eq? result 'win)
                  "¡Ganaste!"
                  "Perdiste :(")])
  (new button%
       [parent panel]
       [label "Volver al inicio"]
       [callback (lambda (_btn _evt)
                   (reset-game-state!)
                   (set-screen 'start))])
                   
  ;; =============================== BOTÓN: JUGAR DE NUEVO ===============================
  (new button%
       [parent panel]
       [label "Jugar de nuevo"]
       [callback (lambda (_btn _evt)
                   (reset-game-state!)
                   (set-screen 'game))])
  panel)