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

(provide move-diagonally-loop check-diagonal-loop)

;
; move diagonally loop
;
(define (move-diagonally-loop coord)

   (for-loop 3
    (lambda () #f)
    (lambda () (set! coord (moving coord #:depth 1))))
   
   (for-loop 3
    (lambda () #f)
    (lambda () (set! coord (moving coord #:depth 1))))

   coord)

(define (check-diagonal-loop impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x 3) new-x))
     (assert (= (- y 3) new-y))]))

(do-synthesis check-diagonal-loop move-diagonally-loop)
