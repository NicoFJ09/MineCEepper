#lang racket/gui

;; ===============================================================================================
;; START.RKT - Pantalla de inicio y configuración del juego
;; ===============================================================================================
;; Funcionalidad: Interfaz para seleccionar configuración del juego
;; - Selección de tamaño del tablero (8x8, 10x10, 12x12, 15x15)
;; - Selección de dificultad (Fácil 10%, Medio 15%, Difícil 20%)
;; - Botón para iniciar nueva partida
;; ===============================================================================================

(provide show-start-screen)
(require "../../utils/state.rkt")

;; =============================== UI: PANTALLA DE INICIO ===============================
(define (show-start-screen mainWindow)
  (define main-panel (new vertical-panel% [parent mainWindow]))
  
  ;; Título
  (new message% [parent main-panel] 
       [label "MineCEepper"]
       [font (make-object font% 24 'default 'normal 'bold)])
  
  (new message% [parent main-panel] [label ""])  ; Espaciado
  
  ;; Selección de tamaño
  (new message% [parent main-panel] [label "Tamaño del tablero:"])
  (define size-panel (new horizontal-panel% [parent main-panel]))
  
  (define size-choice (new choice% 
                          [label ""]
                          [parent size-panel]
                          [choices '("8x8" "10x10" "12x12" "15x15")]))
  
  (new message% [parent main-panel] [label ""])  ; Espaciado
  
  ;; Selección de dificultad  
  (new message% [parent main-panel] [label "Dificultad:"])
  (define difficulty-panel (new horizontal-panel% [parent main-panel]))
  
  (define difficulty-choice (new choice%
                                [label ""]
                                [parent difficulty-panel]
                                [choices '("Fácil (10%)" "Medio (15%)" "Difícil (20%)")]))
  
  (new message% [parent main-panel] [label ""])  ; Espaciado
  
  ;; Botón para iniciar juego
  (new button%
    [parent main-panel]
    [label "¡Iniciar Juego!"]
    [callback (lambda (_btn _evt)
                (start-new-game size-choice difficulty-choice))])
  
  main-panel)

;; =============================== LÓGICA: INICIAR NUEVO JUEGO ===============================
(define (start-new-game size-choice difficulty-choice)
  ;; Obtener tamaño seleccionado
  (define size-index (send size-choice get-selection))
  (define sizes '((8 8) (10 10) (12 12) (15 15)))
  (define selected-size (list-ref sizes size-index))
  (define rows (car selected-size))
  (define cols (cadr selected-size))
  
  ;; Obtener dificultad seleccionada  
  (define difficulty-index (send difficulty-choice get-selection))
  (define difficulty (+ difficulty-index 1)) ; 0->1, 1->2, 2->3
  
  ;; Configurar el juego
  (set-game-config! rows cols difficulty)
  
  ;; Ir a la pantalla de juego
  (set-screen 'game))