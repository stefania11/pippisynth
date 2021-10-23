#lang rosette
(require rosette/lib/synthax)     ; Require the sketching library.
(require racket/match)


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

; CHECKER
(define (check-diag impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x 1) new-x))
     (assert (= (- y 1) new-y))]
    [_ "error wrong format for coordinate"]))

(define (check-same impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= x new-x))
     (assert (= y new-y))]))

(define (check-one impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x 1) new-x))
     (assert (= y new-y))]))

(define-symbolic x y integer?) 
(define symbol-coord (list x y))

; EXAMPLE 1
(define (same-coord coord)
  (moving coord #:depth 1))

(define sol-same
  (synthesize
   #:forall symbol-coord
   #:guarantee (check-same same-coord symbol-coord)))

(print-forms sol-same)
; solution: (define (same-coord coord) coord)

; EXAMPLE 2
(define (one-coord coord)
  (moving coord #:depth 2))

(define sol-one
  (synthesize
   #:forall symbol-coord
   #:guarantee (check-one one-coord symbol-coord)))

(print-forms sol-one)
; solution: (define (one-coord coord) (moveLeft coord))

; EXAMPLE 3
(define (go-diagonally coord)
  (moving coord #:depth 3))

(define sol
  (synthesize
   #:forall (list x y)
   #:guarantee (check-diag go-diagonally (list x y))))

(print-forms sol)
; solution: (define (go-diagonally coord) (moveLeft (moveUp coord)))
