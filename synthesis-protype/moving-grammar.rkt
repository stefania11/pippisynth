#lang rosette
(require rosette/lib/synthax)     ; Require the sketching library.
(require racket/match)


(provide 
  moveLeft
  moveRight
  moveUp
  moveDown
  moving
)


; DEFINITIONS
(define (moveLeft coord)
  (match coord
    [(list x y) (list (- x 1) y)]
    [_ "error wrong format for coordinate"]))

(define (moveRight coord)
  (match coord
    [(list x y) (list (+ x 1) y)]
    [_ "error wrong format for coordinate"]))

(define (moveUp coord)
  (match coord
    [(list x y) (list x (- y 1))]
    [_ "error wrong format for coordinate"]))

(define (moveDown coord)
  (match coord
    [(list x y) (list x (+ y 1))]
    [_ "error wrong format for coordinate"]))

; GRAMMAR
(define-grammar (moving coord)
  [expr
   (choose coord
           (moveUp (expr))
           (moveLeft (expr))
           (moveDown (expr))
           (moveRight (expr)))])