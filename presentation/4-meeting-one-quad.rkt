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

(provide meeting-one-quad checker-one-quad)

;
; meeting one quad
;
(define (meeting-one-quad coord-start coord-end)

   (define coord-curr coord-start)

   (for-loop 7
    (lambda () (bi-conditional coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))

   (for-loop 7
    (lambda () (bi-conditional coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))

   coord-curr)

(define (checker-one-quad impl coord-start coord-end)
  (destruct (append coord-start coord-end)
    [(list x1 y1 x2 y2)

      (define range 7)
      (define new-coord (impl coord-start coord-end))

      (assert (implies 

                ; the following ensures we have the correct
                ;    starting constraints to be able to synthesize
                ;    our goal
                (and
                    ; this is saying that (x2-range) <= x1 <= x2
                    (<= x1 x2)
                    (>= x1 (- x2 range))

                    ; this is saying that (y2-range) <= y1 <= y2
                    (<= y1 y2)
                    (>= y1 (- y2 range))
                )

                (coord-equals new-coord coord-end) ) ) ] ) )
                
(do-synthesis-bi checker-one-quad meeting-one-quad)
