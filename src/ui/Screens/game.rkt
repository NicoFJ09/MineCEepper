#lang racket/gui

;; ===============================================================================================
;; GAME.RKT - Pantalla principal del juego MineCEepper
;; ===============================================================================================
;; Funcionalidad:
;; - Interfaz gráfica del tablero de buscaminas
;; - Matriz de botones interactivos con assets visuales
;; - Manejo de clicks (revelación y banderas)
;; - Lógica de victoria/derrota con timers
;; - Revelación en cascada para áreas vacías
;; - Estado de celdas reveladas/con banderas
;; ===============================================================================================

(provide show-game-screen)

;; -------------------------------------------------------------------------------
;; IMPORTS
;; -------------------------------------------------------------------------------
(require "../../utils/state.rkt"
         "../../utils/game/game-integration.rkt"
         "../../utils/map/bomb.rkt"
         "../../core/map.rkt"
         "../../utils/game/cell-status.rkt"
         "../../utils/game/events.rkt"
         "../../utils/game/interactions.rkt")

;; -------------------------------------------------------------------------------
;; ESTADO GLOBAL DE LA UI (Referencia a los botones del tablero)
;; -------------------------------------------------------------------------------
(define game-buttons (box '())) 

;; -------------------------------------------------------------------------------
;; CREACIÓN DE BOTONES DE CELDA (Con imagen y callback correspondiente)
;; -------------------------------------------------------------------------------

(define (create-cell-button parent row col)
  (define cell-value 0)  ; Valor temporal (antes de revelar)
  (define is-revealed (get-cell-revealed row col))
  (define is-flagged (get-cell-flagged row col))
  (define asset-path "./assets/tiles/tile.png")  ; Imagen inicial (celda oculta)
  (define button
    (new button%
         [parent parent]
         [label (load-image asset-path)]
         [min-width 25]
         [min-height 25]
         [horiz-margin 0]
         [vert-margin 0]
         [stretchable-width #f]
         [stretchable-height #f]
         [callback (lambda (button event)
                     (cond
                       [(unbox flag-mode)
                        (handle-flag-click row col button update-button-image)]
                       [else 
                        (handle-cell-click row col button
                                           is-first-click? generate-game-map set-first-click!
                                           get-game-map get-game-config get-screen set-screen
                                           cancel-global-timer! set-game-timer!
                                           reveal-cell update-button-image set-cell-flagged)]))]))
  (store-button row col button)
  button)

;; -------------------------------------------------------------------------------
;; UTILIDADES DE BOTONES
;; -------------------------------------------------------------------------------

;; Guarda la referencia a un botón en la matriz global
(define (store-button row col button)
  (define buttons-matrix (unbox game-buttons))
  (set-box! game-buttons (cons (list row col button) buttons-matrix)))

;; Obtiene el botón correspondiente a una celda
(define (get-button row col)
  (define buttons-list (unbox game-buttons))
  (define found (filter (lambda (item) 
                         (and (= (car item) row) 
                              (= (cadr item) col))) 
                       buttons-list))
  (if (null? found) #f (caddr (car found))))

;; Actualiza la imagen de un botón de celda
(define (update-button-image row col new-asset-path)
  (define button (get-button row col))
  (when button
    (send button set-label (load-image new-asset-path))))

;; -------------------------------------------------------------------------------
;; FUNCIONES DE REVELADO Y BANDERAS (Revela una celda específica y actualiza la UI)
;; -------------------------------------------------------------------------------

(define (reveal-cell row col cell-value)
  (printf "Revelando celda [~a,~a] con valor ~a~n" row col cell-value)
  (set-cell-revealed row col #t)
  (update-cell-visual row col (get-game-map) get-cell-asset-path update-button-image)
  (yield))

;; -------------------------------------------------------------------------------
;; MODO BANDERA
;; -------------------------------------------------------------------------------

(define flag-mode (box #f)) ; Estado global del modo bandera

;; Alterna el modo bandera (solo por botón)
(define (toggle-flag-mode)
  (define current-mode (unbox flag-mode))
  (set-box! flag-mode (not current-mode))
  (printf "Modo bandera: ~a~n" (if (not current-mode) "ACTIVADO" "DESACTIVADO")))

;; -------------------------------------------------------------------------------
;; INICIALIZACIÓN DEL ESTADO DEL JUEGO (Inicializa matrices de estado y botones al comenzar una partida)
;; -------------------------------------------------------------------------------

(define (init-game-state rows cols)
  (printf "INIT: Inicializando estado del juego~n")
  (cancel-global-timer!)
  (define empty-row (for/list ([i cols]) #f))
  (define empty-matrix (for/list ([i rows]) empty-row))
  (set-box! revealed-cells empty-matrix)
  (set-box! flagged-cells empty-matrix)
  (set-box! game-buttons '())
  (set-box! flag-mode #f))

;; -------------------------------------------------------------------------------
;; UI PRINCIPAL DEL JUEGO (Construye la pantalla principal del juego y todos sus componentes)
;; -------------------------------------------------------------------------------

(define (show-game-screen mainWindow)
  (reset-game-state!)
  (define config (get-game-config))
  (define rows (game-vars-rows config))
  (define cols (game-vars-cols config))
  (init-game-state rows cols)
  (define main-panel (new vertical-panel% [parent mainWindow]))
  (define info-panel (new horizontal-panel% [parent main-panel] [min-height 50]))
  (define difficulty-name 
    (cond
      [(equal? (game-vars-difficulty config) 1) "Fácil"]
      [(equal? (game-vars-difficulty config) 2) "Medio"] 
      [(equal? (game-vars-difficulty config) 3) "Difícil"]
      [else "Desconocido"]))
  (new message% [parent info-panel] 
       [label (string-append "MineCEepper - " 
                            (number->string rows) "x" (number->string cols)
                            " - " difficulty-name)])
  (new button% [parent info-panel] [label "Nuevo Juego"] 
       [callback (lambda (btn evt) (set-screen 'game))])
  (new button% [parent info-panel] [label "🚩 Modo Bandera"] 
       [callback (lambda (btn evt) (toggle-flag-mode))])
  (new button% [parent info-panel] [label "Menú"] 
       [callback (lambda (btn evt) (set-screen 'start))])
  (define game-panel (new vertical-panel% 
                         [parent main-panel] 
                         [spacing 0]
                         [horiz-margin 5]
                         [vert-margin 5]))
  (for ([row-idx rows])
    (define row-panel (new horizontal-panel% 
                          [parent game-panel] 
                          [horiz-margin 0] 
                          [vert-margin 0]
                          [spacing 0]
                          [stretchable-height #f]))
    (for ([col-idx cols])
      (create-cell-button row-panel row-idx col-idx)))
  main-panel)