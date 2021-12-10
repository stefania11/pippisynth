#lang rosette/safe

(require
  rosette/lib/synthax
  rosette/lib/destruct
  racket/match
)

(require 
  "moving-grammar.rkt" 
  "for-loop.rkt"
  "synthesis.rkt"
)



;
; move diagonally
;
(define (move-diagonally coord)
  (define coord1 (moving coord   #:depth 1))
  (define coord2 (moving coord1  #:depth 1))
  (define coord3 (moving coord2  #:depth 1))
  (define coord4 (moving coord3  #:depth 1))
  (define coord5 (moving coord4  #:depth 1))
  (define coord6 (moving coord5  #:depth 1))
   coord6)




(define (check-diagonal impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x 3) new-x))
     (assert (= (- y 3) new-y))]))

(do-synthesis check-diagonal move-diagonally)
