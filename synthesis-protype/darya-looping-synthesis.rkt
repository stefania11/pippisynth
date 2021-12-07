#lang rosette
; #lang rosette/safe

(require
  rosette/lib/synthax
  rosette/lib/destruct
)

(require 
  "moving-grammar.rkt" 
)

(require racket/sandbox)


; Define a counting loop:
; defines a loop that iterates up to n times, calling body in each iteration, and
; breaking out when calling break-cond is true.  See below for sample usage. 
(define (for-loop n break-cond body)
  (cond
    [(break-cond) '()] ; break and return an empty list (TODO: is there a more reasonable value?)
    [(<= n 1) (body)]  ; perform the last iteration and return its value 
    [else (begin
            (body)
            (for-loop (sub1 n) break-cond body))]))


;
; Coordinate stuff
;

(define (fresh-sym-coord) 
  (define-symbolic* x y integer?)
  (list x y))

(define (coord-equals coord coord2)
  (destruct (append coord coord2)
    [(list x y x2 y2)
     (and (= x x2)
          (= y y2))]))

(define (same-x coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x y x2 y2)
      (= x x2)]))

(define (same-y coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (= y1 y2)]))

; (coord2) ... (coord1)
(define (is-to-right coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
        (> x1 x2)
    ]
  )
)

; (coord1) ... (coord2)
(define (is-to-left coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (< x1 x2)
    ]
  )
)

; (coord2) 
; ...
; (coord1)
(define (is-below coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (> y1 y2)
    ]
  )
)

; (coord1) 
; ...
; (coord2)
(define (is-above coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (< y1 y2)
    ]
  )
)


;
; Conditional grammar
;

(define-grammar (bi-conditional coord1 coord2)
    [expr
        (choose 
                (same-x coord1 coord2)
                (same-y coord1 coord2)

                (is-to-right coord1 coord2)
                (is-to-left coord1 coord2)
                (is-below coord1 coord2)
                (is-above coord1 coord2)
        )
    ]
)

    
;
; SKETCHES
;

; sketch for moving from `coord-start` to `coord-end`
;    ONLY in 1 quadrant
(define (sk-meet-1-quad range coord-start coord-end)
  (define coord-curr coord-start)
  (for-loop (* 2 range)
    (lambda () (bi-conditional coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  (for-loop (* 2 range)
    (lambda () (bi-conditional coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  coord-curr
)

#|
solution:

(define (sk-meet-1-quad-sol range coord-start coord-end)
   (define coord-curr coord-start)
   (for-loop (* 2 range)
    (lambda () (same-x coord-curr coord-end))
    (lambda () (set! coord-curr (moveRight coord-curr))))
   (for-loop (* 2 range)
    (lambda () (same-y coord-curr coord-end))
    (lambda () (set! coord-curr (moveDown coord-curr))))
   coord-curr)

|#

; sketch for moving from `coord-start` to `coord-end`
;    works for all 4 quadrants
(define (sk-meet-4-quads range coord-start coord-end)
  (define coord-curr coord-start)
  (for-loop (* 2 range)
    (lambda () (coord-equals coord-curr coord-end))
    (lambda () (cond
        [(bi-conditional coord-curr coord-end #:depth 1)
            (set! coord-curr (moving coord-curr #:depth 1))]
        [(bi-conditional coord-curr coord-end #:depth 1)
            (set! coord-curr (moving coord-curr #:depth 1))]
        [(bi-conditional coord-curr coord-end #:depth 1)
            (set! coord-curr (moving coord-curr #:depth 1))]
        [(bi-conditional coord-curr coord-end #:depth 1)
            (set! coord-curr (moving coord-curr #:depth 1))])))
  coord-curr
)

#|
solution:

(define (sk-meet-4-quads-sol range coord-start coord-end)
   (define coord-curr coord-start)
   (for-loop (* 2 range)
    (lambda () (coord-equals coord-curr coord-end))
    (lambda ()
      (cond
       [(is-above coord-curr coord-end)
          (set! coord-curr (moveDown coord-curr))]
       [(is-below coord-curr coord-end) 
          (set! coord-curr (moveUp coord-curr))]
       [(is-to-left coord-curr coord-end)
          (set! coord-curr (moveRight coord-curr))]
       [(is-to-right coord-curr coord-end)
          (set! coord-curr (moveLeft coord-curr))])))
   coord-curr)

|#



;
; CHECKERS
;

(define (checker-1-quad range impl coord-start coord-end)
  (destruct (append coord-start coord-end)
    [(list x1 y1 x2 y2)

      (define new-coord (impl range coord-start coord-end))

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

                (coord-equals new-coord coord-end)
              )
      )
    ]
  )
)

(define (checker-4-quads range impl coord-start coord-end)
  (destruct (append coord-start coord-end)
    [(list x1 y1 x2 y2)

      (define new-coord (impl range coord-start coord-end))

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

                (coord-equals new-coord coord-end)
              )
      )
    ]
  )
)


;
; SOLVERS
;

(define (do-synthesis-bi range checker sketch)

    (define symbol-coord-start (fresh-sym-coord))
    (define symbol-coord-end   (fresh-sym-coord))

    (define before (current-inexact-milliseconds))
    (define sol-same
      (synthesize
              #:forall (list symbol-coord-start symbol-coord-end)
              #:guarantee (checker range sketch symbol-coord-start symbol-coord-end)))
    
    (define after (current-inexact-milliseconds))
    (define time (- after before))

    (if (sat? sol-same) 
            (begin 
                (printf "solution:\n")
                (print-forms sol-same))
            (begin
                (printf "no solution found\n")))
) 


;
; RUNNING SYNTHESIS
;

(define range 7)
(do-synthesis-bi range checker-1-quad sk-meet-1-quad)
(newline)
(do-synthesis-bi range checker-4-quads sk-meet-4-quads)