#lang racket/gui

(provide draw-matrix)

(define (draw-matrix mainWindow)
  
; Pasar luego n filas y m filas pasadas del input del menu
(define tamaño (cons 13 10))

; Contenedor principal del juego
(define game-container (new vertical-panel%
                         [parent mainWindow]))

; Panel superior (contador de minas, tiempo)
(define panel-superior (new horizontal-panel%
                        [parent game-container]
                        (min-width 0)
                        (min-height 50)))

; Zona de matriz de juego
(define panel-juego (new horizontal-panel%
                        [parent game-container]
                        (min-width 0)
                        (min-height 0)))

(define (cargar-imagen ruta)
  (read-bitmap ruta))

(define (crear-boton-imagen parent ruta-imagen callback)
  (let ([imagen (cargar-imagen ruta-imagen)])
    (new button%
         [parent parent]
         [label imagen]
         [horiz-margin 0]
         [vert-margin 0]
         [callback callback])))

; Contenido del panel superior 
(new canvas% [parent panel-superior]
             [paint-callback
              (lambda (canvas dc1)
                (send dc1 set-pen "#bebebe" 0 'transparent)
                (send dc1 set-brush "#bebebe" 'solid)
                (send dc1 draw-rectangle 0 0 1000 200)
                (send dc1 set-scale 2 2)
                (send dc1 set-text-foreground "white")
                (send dc1 draw-text "MineCEeper" 0 0))])

; Insertar imagen en boton cuando lee dicho numero en celda
(define celdas 
  (for ([i (in-range (car tamaño))])
    (define col-panel (new vertical-panel% [parent panel-juego]))
    (for ([j (in-range (cdr tamaño))])
      (crear-boton-imagen
        col-panel
        "./assets/tiles/tile.png" 
        (lambda (button event)  ; Callback para manejar clicks
          (printf "Botón clickeado en posición ~a,~a~n" i j))))))

  game-container)