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

(printf "\n========\nBEFORE: \n")
(clear-vc!)
(choose*  1 2 3 4 5)
(vc)

; Emina's encoding. Part 1. This just selects among the procedures. 
(printf "\n========\nPART 1: \n")
(clear-vc!)
(sym-op)
(vc)

; Emina's encoding. Part 1 + Part 2. This selects among the procedures and calls the chosen procedure. 
(printf "\n========\nPART 1 + PART 2: \n")
(clear-vc!)
((sym-op) x)
(vc)

; Our new grammar. Like the original but only 1-deep and uses choose*
(printf "\n========\nCHOOSE*: \n")
(clear-vc!)
(moving-new x)
(vc)

; Our orignal grammar. Depth 0 since the vc is quite large for depth 1. 
(printf "\n========\nDEPTH 0: \n")
(clear-vc!)
(moving x #:depth 0) ; Depth 0  !!!!  Depth 1 is below. 
(vc)

; Our orignal grammar. Depth 0 since the vc is quite large for depth 1. 
(printf "\n========\nDEPTH 1: \n")
(clear-vc!)
(moving x #:depth 1) 
(vc)
