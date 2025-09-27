#lang racket/gui

;; ===============================================================================================
;; START.RKT - Pantalla de inicio y configuración del juego
;; ===============================================================================================
;; Funcionalidad: Interfaz para seleccionar configuración del juego
;; - Configuración manual de dimensiones del tablero (8-15 filas/columnas)
;; - Selección de dificultad (Fácil 10%, Medio 15%, Difícil 20%)
;; - Validación de entrada para asegurar valores en rango válido
;; - Botón para iniciar nueva partida con configuración personalizada
;; ===============================================================================================

(provide show-start-screen)
(require "../../utils/state.rkt")

;; =============================== UI: PANTALLA DE INICIO ===============================
(define (show-start-screen mainWindow)
  (define main-panel (new vertical-panel% [parent mainWindow]
                          [horiz-margin 2]
                          [vert-margin 2]
                          [spacing 0]
                          [alignment '(center center)]
                          [stretchable-height #t]))
  ;; Panel superior: título y rango
  (define top-panel (new vertical-panel% [parent main-panel]
                        [alignment '(center center)]
                        [spacing 0]))
  (new message% [parent top-panel] 
    [label "MineCEepper"]
    [font (make-object font% 32 'default 'normal 'bold)])
  (new message% [parent top-panel]
    [label "Rango permitido: 8-15 para filas y columnas"]
    [font (make-object font% 16 'default 'normal 'normal)])
  ;; Panel de inputs
  (define size-panel (new horizontal-panel% [parent main-panel]
                         [alignment '(center center)]
                         [spacing 0]))
  (new message% [parent size-panel] [label "Filas:"])
  (define rows-field (new text-field% 
                         [label ""]
                         [parent size-panel]
                         [init-value "8"]
                         [min-width 60]))
  (new message% [parent size-panel] [label "Columnas:"])
  (define cols-field (new text-field% 
                         [label ""]
                         [parent size-panel]
                         [init-value "8"]
                         [min-width 60]))
  ;; Panel de dificultad
  (define difficulty-panel (new horizontal-panel% [parent main-panel]
                                [alignment '(center center)]
                                [spacing 0]))
  (new message% [parent difficulty-panel] [label "Dificultad:"])
  (define difficulty-choice (new choice%
                                [label ""]
                                [parent difficulty-panel]
                                [choices '("Fácil (10%)" "Medio (15%)" "Difícil (20%)")]))
  ;; Panel de botón centrado
  (define button-panel (new vertical-panel% [parent main-panel]
                           [alignment '(center center)]
                           [spacing 0]))
  (new button%
    [parent button-panel]
    [label "¡Iniciar Juego!"]
    [min-width 180]
    [callback (lambda (_btn _evt)
                (start-new-game rows-field cols-field difficulty-choice))])
  main-panel)

;; =============================== LÓGICA: INICIAR NUEVO JUEGO ===============================
(define (start-new-game rows-field cols-field difficulty-choice)
  ;; Obtener valores ingresados manualmente
  (define rows-text (send rows-field get-value))
  (define cols-text (send cols-field get-value))
  
  ;; Validar y convertir a números
  (define rows (string->number rows-text))
  (define cols (string->number cols-text))
  
  ;; Validar rango (8-15)
  (cond
    [(or (not rows) (not cols) 
         (< rows 8) (> rows 15) 
         (< cols 8) (> cols 15))
     (message-box "Error de Validación" 
                  "Por favor ingrese números válidos entre 8 y 15 para filas y columnas."
                  #f '(ok))]
    [else
     ;; Obtener dificultad seleccionada  
     (define difficulty-index (send difficulty-choice get-selection))
     (define difficulty (+ difficulty-index 1)) ; 0->1, 1->2, 2->3
     
     ;; Configurar el juego
     (set-game-config! rows cols difficulty)
     
     ;; Ir a la pantalla de juego
     (set-screen 'game)]))