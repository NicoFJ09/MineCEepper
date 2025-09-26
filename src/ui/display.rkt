#lang racket/gui

;; ===============================================================================================
;; DISPLAY.RKT - Coordinador de pantallas del juego
;; ===============================================================================================
;; Funcionalidad: Maneja la navegación y visualización entre diferentes pantallas
;; - Limpia y cambia contenido de la ventana según estado actual
;; - Coordina transiciones entre start, game, win, lose
;; - Funciones de utilidad para manipulación de UI
;; ===============================================================================================

(provide display-screen)
(require "../utils/state.rkt"
         "Screens/start.rkt"
         "Screens/game.rkt"
         "Screens/end.rkt")

(define (remove-all-children parent)
  (for ([child (send parent get-children)])
    (send parent delete-child child)))

(define (display-screen mainWindow)
  (printf "DISPLAY: Mostrando pantalla ~a~n" (get-screen))
  (remove-all-children mainWindow)
  (cond
    [(eq? (get-screen) 'start) 
     (printf "DISPLAY: Cargando pantalla START~n")
     (show-start-screen mainWindow)]
    [(eq? (get-screen) 'game)  
     (printf "DISPLAY: Cargando pantalla GAME~n")
     (show-game-screen mainWindow)]
    [(eq? (get-screen) 'win)   
     (printf "DISPLAY: Cargando pantalla WIN~n")
     (show-end-screen mainWindow 'win)]
    [(eq? (get-screen) 'lose)  
     (printf "DISPLAY: Cargando pantalla LOSE~n")
     (show-end-screen mainWindow 'lose)]
    [else                      
     (printf "DISPLAY: Pantalla desconocida, usando START por defecto~n")
     (show-start-screen mainWindow)]))