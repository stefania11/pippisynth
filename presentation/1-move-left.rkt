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

(provide move-left check-left)

;
; move once
;
(define (move-left coord) 
    (moving coord #:depth 1))

(define (check-left impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x 1) new-x))
     (assert (= y new-y))]))

(do-synthesis check-left move-left)

