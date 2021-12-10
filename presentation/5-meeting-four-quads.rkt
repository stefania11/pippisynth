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
; meeting 4 quads
;
(define (meeting-four-quads coord-start coord-end)

  (define coord-curr coord-start)

  (for-loop 14

    (lambda () (coord-equals coord-curr coord-end))
    (lambda () (cond

          [(bi-conditional coord-curr coord-end #:depth 1)
            (set! coord-curr (moving coord-curr #:depth 1))]

          [(bi-conditional coord-curr coord-end #:depth 1)
            (set! coord-curr (moving coord-curr #:depth 1))]

          [(bi-conditional coord-curr coord-end #:depth 1)
            (set! coord-curr (moving coord-curr #:depth 1))]

          [(bi-conditional coord-curr coord-end #:depth 1)
            (set! coord-curr (moving coord-curr #:depth 1))
          ])))

  coord-curr)


(define (checker-four-quads impl coord-start coord-end)
  (destruct (append coord-start coord-end)
    [(list x1 y1 x2 y2)

      (define range 7)
      (define new-coord (impl coord-start coord-end))

      (assert (implies 

                ; the following ensures we have the correct
                ;    starting constraints to be able to synthesize
                ;    our goal
                (and
                    ; this is saying that (x2-range) <= x1 <= (x2+range)
                    (<= x1 (+ x2 range))
                    (>= x1 (- x2 range))

                    ; this is saying that (y2-range) <= y1 <= (y2+range)
                    (<= y1 (+ y2 range))
                    (>= y1 (- y2 range))
                )

                (coord-equals new-coord coord-end) ) ) ] ) )
                
(do-synthesis-bi checker-four-quads meeting-four-quads)
