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
  (define main-panel (new vertical-panel% [parent mainWindow]))
  
  ;; Título
  (new message% [parent main-panel] 
       [label "MineCEepper"]
       [font (make-object font% 24 'default 'normal 'bold)])
  
  (new message% [parent main-panel] [label ""])  ; Espaciado
  
  ;; Configuración de tamaño personalizado
  (new message% [parent main-panel] [label "Tamaño del tablero (8-15):"])
  (define size-panel (new horizontal-panel% [parent main-panel]))
  
  ;; Campo para filas
  (new message% [parent size-panel] [label "Filas:"])
  (define rows-field (new text-field% 
                         [label ""]
                         [parent size-panel]
                         [init-value "8"]
                         [min-width 60]))
  
  (new message% [parent size-panel] [label "   Columnas:"])
  (define cols-field (new text-field% 
                         [label ""]
                         [parent size-panel]
                         [init-value "8"]
                         [min-width 60]))
  
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