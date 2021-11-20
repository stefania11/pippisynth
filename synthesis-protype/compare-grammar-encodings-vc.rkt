#lang rosette

(require racket/pretty)
(error-print-width 10000000)

(require rosette/lib/angelic)
(require rosette/lib/synthax)

(define-symbolic x y z w integer?)
(define-symbolic* xx yy integer?) 

  
(define (nop coord) coord)
(define (moveUp coord) xx)
(define (moveRight coord) yy)

(define-grammar (moving coord)
  [expr
   (choose coord
           (moveUp (expr))
           (moveRight (expr)))])

(define (sym-op)
  (choose*
   nop moveUp moveRight))

(define (moving-new coord)
   (choose* coord
            (moveUp coord)
            (moveRight coord)))
           
;;;;;;;;;;;;;;;;;;;;;;;;;
;

(clear-vc!)
(choose*  1 2 3 4 5)
(vc)

; Emnina's encoding. This just selects among the procedures. 
(clear-vc!)
(sym-op)
(vc)

; Emnina's encoding. This selects among the procedures and calls the chosen procedure. 
(clear-vc!)
((sym-op) x)
(vc)

; Our new grammar. Like the original but only 1-deep and uses choose*
(clear-vc!)
(moving-new x)
(vc)

; Our orignal grammar. Depth 0 since the vc is quite large for depth 1. 
(clear-vc!)
(moving x #:depth 0) ; Depth 0  !!!!  Depth 1 is below. 
(vc)

; Our orignal grammar. Depth 0 since the vc is quite large for depth 1. 
(clear-vc!)
(moving x #:depth 1) 
(vc)




