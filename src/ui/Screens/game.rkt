#lang racket/gui

;; ===============================================================================================
;; GAME.RKT - Pantalla principal del juego (tablero interactivo)
;; ===============================================================================================
;; Funcionalidad: Interfaz del tablero de buscaminas con interacción completa
;; - Matriz de botones interactivos con assets visuales
;; - Manejo de clicks (revelación y banderas)
;; - Lógica de victoria/derrota con timers
;; - Revelación en cascada para áreas vacías
;; - Estado de celdas reveladas/con banderas
;; ===============================================================================================

(provide show-game-screen)
(require "../../utils/state.rkt"
         "../../utils/game/game-integration.rkt"
         "../../utils/map/bomb.rkt"
         "../../core/map.rkt")

;; Estado de revelación y banderas (temporal - matrices de booleans)
(define revealed-cells (box '()))
(define flagged-cells (box '()))
(define game-buttons (box '())) ; Para poder actualizar botones
(define flag-mode (box #f))     ; Modo bandera activado/desactivado

;; Función para cargar imagen
(define (load-image path)
  (read-bitmap path))

;; Crear botón con imagen para una celda
(define (create-cell-button parent row col)
  ;; Al inicio, todas las celdas están ocultas (sin mapa generado aún)
  (define cell-value 0)  ; Valor temporal
  (define is-revealed (get-cell-revealed row col))
  (define is-flagged (get-cell-flagged row col))
  (define asset-path "./assets/tiles/tile.png")  ; Siempre tile oculto al inicio
  
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
                        (handle-flag-click row col button)]
                       [else 
                        (handle-cell-click row col button)]))]))
  
  ;; Guardar referencia al botón para poder actualizarlo
  (store-button row col button)
  button)

;; Obtener estado de revelación de celda
(define (get-cell-revealed row col)
  (define revealed-matrix (unbox revealed-cells))
  (cond
    [(or (null? revealed-matrix) (>= row (length revealed-matrix))) #f]
    [(>= col (length (car revealed-matrix))) #f]
    [else (list-ref (list-ref revealed-matrix row) col)]))

;; Obtener estado de bandera de celda  
(define (get-cell-flagged row col)
  (define flagged-matrix (unbox flagged-cells))
  (cond
    [(or (null? flagged-matrix) (>= row (length flagged-matrix))) #f]
    [(>= col (length (car flagged-matrix))) #f]
    [else (list-ref (list-ref flagged-matrix row) col)]))

;; Guardar referencia a botón
(define (store-button row col button)
  (define buttons-matrix (unbox game-buttons))
  ;; Por simplicidad, usamos una lista de tuplas (row col button)
  (set-box! game-buttons (cons (list row col button) buttons-matrix)))

;; Obtener botón por coordenadas
(define (get-button row col)
  (define buttons-list (unbox game-buttons))
  (define found (filter (lambda (item) 
                         (and (= (car item) row) 
                              (= (cadr item) col))) 
                       buttons-list))
  (if (null? found) #f (caddr (car found))))

;; Actualizar imagen de botón
(define (update-button-image row col new-asset-path)
  (define button (get-button row col))
  (when button
    (send button set-label (load-image new-asset-path))))

;; Manejar click izquierdo en celda - CON GENERACIÓN DIFERIDA
(define (handle-cell-click row col button)
  (define is-flagged (get-cell-flagged row col))
  (define is-already-revealed (get-cell-revealed row col))
  
  ;; No hacer nada si la celda tiene bandera o ya está revelada
  (when (and (not is-flagged) (not is-already-revealed))
    
    ;; PRIMER CLICK: Generar mapa evitando esta posición
    (when (is-first-click?)
      (printf "PRIMER CLICK en [~a,~a] - Generando mapa seguro...~n" row col)
      (generate-game-map row col)
      (set-first-click! #f))
    
    ;; Obtener el mapa ya generado
    (define game-map (get-game-map))
    (define cell-value (list-ref (list-ref game-map row) col))
    
    (printf "Click en celda [~a,~a] - Valor: ~a~n" row col cell-value)
    
    ;; LÓGICA DE REVELACIÓN DIFERENTE SEGÚN VALOR
    (cond
      [(equal? cell-value 'X) 
       (printf "¡BOOM! Mina encontrada - Game Over~n")
       (reveal-cell row col cell-value)
       (reveal-all-mines game-map)
       ;; Cancelar timer existente y crear uno nuevo
       (cancel-global-timer!)
       (define timer (new timer% 
                        [notify-callback (lambda ()
                                          (printf "TIMER: Ejecutando cambio a lose~n")
                                          (when (not (eq? (get-screen) 'lose))
                                            (set-screen 'lose)))]
                         [interval 1000]
                         [just-once? #t]))
       ;; Guardar referencia al timer global
       (set-game-timer! timer)
       (send timer start)]
      
      [(equal? cell-value 0) 
       (printf "Celda vacía - Revelando área...~n")
       (reveal-empty-area row col)  ; Nueva función para revelación en cascada
       ;; Verificar victoria después de revelación en cascada
       (check-victory!)]
      
      [else 
       (printf "Celda con número ~a~n" cell-value)
       (reveal-cell row col cell-value)
       ;; Verificar victoria después de revelar celda individual
       (check-victory!)])))

;; Manejar click bandera
(define (handle-flag-click row col button)
  (define is-flagged (get-cell-flagged row col))
  (define is-revealed (get-cell-revealed row col))
  
  ;; Solo permitir banderas en celdas no reveladas
  (when (not is-revealed)
    (cond
      [is-flagged
       ;; QUITAR bandera
       (printf "Quitando bandera de [~a,~a]~n" row col)
       (set-cell-flagged row col #f)
       ;; Vuelve a mostrar celda oculta (tile.png)
       (update-button-image row col "./assets/tiles/tile.png")]
      [else
       ;; PONER bandera
       (printf "Poniendo bandera en [~a,~a]~n" row col)  
       (set-cell-flagged row col #t)
       ;; Mostrar bandera
       (update-button-image row col "./assets/tiles/flag.png")])))

;; Revelar una celda específica  
(define (reveal-cell row col cell-value)
  (printf "Revelando celda [~a,~a] con valor ~a~n" row col cell-value)
  ;; Marcar como revelada
  (set-cell-revealed row col #t)
  ;; Actualizar visual inmediatamente
  (update-cell-visual row col (get-game-map))
  ;; Forzar refresco de la UI
  (yield))

;; ================= VERIFICACIÓN DE VICTORIA =================
;; Verificar si el jugador ha ganado (todas las celdas no-mina reveladas)
(define (check-victory!)
  (define game-map (get-game-map))
  (define config (get-game-config))
  (define rows (game-vars-rows config))
  (define cols (game-vars-cols config))
  
  ;; Contar celdas totales y minas
  (define total-cells (* rows cols))
  (define total-mines (count_total_bombs game-map))  ; Usar función de map.rkt
  (define safe-cells (- total-cells total-mines))
  
  ;; Contar celdas reveladas (que no son minas)
  (define revealed-safe-cells (count-revealed-safe-cells game-map))
  
  (printf "VICTORIA: ~a/~a celdas seguras reveladas~n" revealed-safe-cells safe-cells)
  
  ;; Si todas las celdas seguras están reveladas = VICTORIA
  (when (= revealed-safe-cells safe-cells)
    (printf "¡VICTORIA! Todas las celdas seguras reveladas~n")
    ;; Cancelar cualquier timer y ir a pantalla de victoria
    (cancel-global-timer!)
    (define timer (new timer% 
                    [notify-callback (lambda ()
                                      (printf "TIMER: Ejecutando cambio a win~n")
                                      (when (not (eq? (get-screen) 'win))
                                        (set-screen 'win)))]
                      [interval 500]  ; Más rápido que game over
                      [just-once? #t]))
    (set-game-timer! timer)
    (send timer start)))

;; Contar celdas reveladas que no son minas - versión funcional
(define (count-revealed-safe-cells game-map)
  (define config (get-game-config))
  (define rows (game-vars-rows config))
  (define cols (game-vars-cols config))
  
  ;; Función recursiva para contar por fila
  (define (count-row row-idx col-idx acc)
    (cond
      [(>= row-idx rows) acc]  ; Terminamos todas las filas
      [(>= col-idx cols) (count-row (+ row-idx 1) 0 acc)]  ; Siguiente fila
      [else
       (define cell-value (list-ref (list-ref game-map row-idx) col-idx))
       (define is-revealed (get-cell-revealed row-idx col-idx))
       ;; Si está revelada Y no es mina, incrementar contador
       (define new-acc (if (and is-revealed (not (equal? cell-value 'X)))
                           (+ acc 1)
                           acc))
       (count-row row-idx (+ col-idx 1) new-acc)]))
  
  (count-row 0 0 0))

;; ================= REVELACIÓN EN CASCADA =================
;; Revelar área vacía recursivamente (algoritmo de flood-fill)
(define (reveal-empty-area start-row start-col)
  (define game-map (get-game-map))
  (define config (get-game-config))
  (define rows (game-vars-rows config))
  (define cols (game-vars-cols config))
  
  ;; Función recursiva para revelación en cascada
  (define (flood-reveal row col)
    (cond
      ;; Fuera de límites
      [(or (< row 0) (>= row rows) (< col 0) (>= col cols)) (void)]
      ;; Ya revelada o con bandera
      [(or (get-cell-revealed row col) (get-cell-flagged row col)) (void)]
      [else
       ;; Obtener valor de la celda
       (define cell-value (list-ref (list-ref game-map row) col))
       ;; Revelar esta celda
       (reveal-cell row col cell-value)
       
       ;; Si es celda vacía (0), continuar con adyacentes
       (when (equal? cell-value 0)
         ;; Revelar las 8 celdas adyacentes
         (flood-reveal (- row 1) (- col 1))  ; Arriba-izquierda
         (flood-reveal (- row 1) col)        ; Arriba
         (flood-reveal (- row 1) (+ col 1))  ; Arriba-derecha
         (flood-reveal row (- col 1))        ; Izquierda
         (flood-reveal row (+ col 1))        ; Derecha
         (flood-reveal (+ row 1) (- col 1))  ; Abajo-izquierda
         (flood-reveal (+ row 1) col)        ; Abajo
         (flood-reveal (+ row 1) (+ col 1)))]))  ; Abajo-derecha
  
  ;; Iniciar revelación desde la posición clickeada
  (flood-reveal start-row start-col))

;; Revelar TODAS las minas (cuando pierdes) - quitar banderas y mostrar minas
(define (reveal-all-mines game-map)
  (define rows (length game-map))
  (define cols (length (car game-map)))
  (printf "MINES: Revelando todas las minas...~n")
  (for ([row rows])
    (for ([col cols])
      (define cell-value (list-ref (list-ref game-map row) col))
      (when (equal? cell-value 'X)
        (printf "MINES: Revelando mina en [~a,~a]~n" row col)
        ;; QUITAR bandera si existe
        (set-cell-flagged row col #f)
        ;; REVELAR la mina 
        (reveal-cell row col cell-value)))))

;; Actualizar visual de una celda
(define (update-cell-visual row col game-map)
  (define cell-value (list-ref (list-ref game-map row) col))
  (define is-revealed (get-cell-revealed row col))
  (define is-flagged (get-cell-flagged row col))
  (define asset-path (get-cell-asset-path cell-value is-revealed is-flagged))
  (update-button-image row col asset-path))

;; Alternar modo bandera
(define (toggle-flag-mode)
  (define current-mode (unbox flag-mode))
  (set-box! flag-mode (not current-mode))
  (printf "Modo bandera: ~a~n" (if (not current-mode) "ACTIVADO" "DESACTIVADO")))

;; Funciones para manejar estado de celdas
(define (set-cell-revealed row col value)
  (set-cell-state revealed-cells row col value))

(define (set-cell-flagged row col value)
  (set-cell-state flagged-cells row col value))

(define (toggle-flag row col)
  (define current-flag (get-cell-flagged row col))
  (set-cell-flagged row col (not current-flag)))

(define (set-cell-state state-box row col value)
  (define matrix (unbox state-box))
  (define new-matrix 
    (for/list ([r (length matrix)])
      (cond
        [(= r row) 
         (for/list ([c (length (list-ref matrix r))])
           (if (= c col) value (list-ref (list-ref matrix r) c)))]
        [else (list-ref matrix r)])))
  (set-box! state-box new-matrix))

;; Inicializar matrices de estado
(define (init-game-state rows cols)
  (printf "INIT: Inicializando estado del juego~n")
  ;; CANCELAR cualquier timer existente PRIMERO
  (cancel-global-timer!)
  
  (define empty-row (for/list ([i cols]) #f))
  (define empty-matrix (for/list ([i rows]) empty-row))
  (set-box! revealed-cells empty-matrix)
  (set-box! flagged-cells empty-matrix)
  (set-box! game-buttons '())  ; Limpiar referencias de botones
  (set-box! flag-mode #f))     ; Resetear modo bandera

;; Pantalla principal de juego
(define (show-game-screen mainWindow)
  ;; RESET del estado del juego para nuevo juego
  (reset-game-state!)
  
  ;; NO generar mapa aún - esperar primer click
  (define config (get-game-config))
  (define rows (game-vars-rows config))
  (define cols (game-vars-cols config))
  
  ;; Inicializar estado del juego sin mapa
  (init-game-state rows cols)
  
  ;; Contenedor principal
  (define main-panel (new vertical-panel% [parent mainWindow]))
  
  ;; Panel superior con info
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
  
  ;; Botones de control
  (new button% [parent info-panel] [label "Nuevo Juego"] 
       [callback (lambda (btn evt) (set-screen 'game))])
  (new button% [parent info-panel] [label "🚩 Modo Bandera"] 
       [callback (lambda (btn evt) (toggle-flag-mode))])
  (new button% [parent info-panel] [label "Menú"] 
       [callback (lambda (btn evt) (set-screen 'start))])
  
  ;; Panel del juego (vertical para las filas) - MUY COMPACTO
  (define game-panel (new vertical-panel% 
                         [parent main-panel] 
                         [spacing 0]
                         [horiz-margin 5]
                         [vert-margin 5]))
  
  ;; Crear matriz de botones SÚPER compacta
  (for ([row-idx rows])
    (define row-panel (new horizontal-panel% 
                          [parent game-panel] 
                          [horiz-margin 0] 
                          [vert-margin 0]
                          [spacing 0]
                          [stretchable-height #f]))  ; Sin espaciado entre botones
    (for ([col-idx cols])
      (create-cell-button row-panel row-idx col-idx)))
  
  main-panel)