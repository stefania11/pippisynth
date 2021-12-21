#lang rosette/safe

(require
  rosette/lib/synthax
  rosette/lib/destruct
)

(require 
  "grammar.rkt" 
  "checker.rkt"
  "coordinates.rkt"
)

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
; SKETCH 1 get from start-point to end-point
;

(define (sk-meet coord-start coord-end)
  (define coord-curr coord-start)
  (for-loop 7
    (lambda () (sameCoord coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  (for-loop 7
    (lambda () (sameCoord coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  coord-curr
)

    
;
; SKETCHES 2 try to get from start-point to end-point on the same line 
;

(define (sk-sameline coord-start coord-end)
  (define coord-curr coord-start)
  (for-loop 7
    (lambda () (oneLine coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  (for-loop 7
    (lambda () (oneLine coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  coord-curr
)


;
; SOLVERS
;

(define (do-synthesis sketch)

    (define symbol-coord-start (fresh-sym-coord))
    (define symbol-coord-end   (fresh-sym-coord))

    (define sol-same
      (synthesize
              #:forall (list symbol-coord-start symbol-coord-end)
              #:guarantee (checker-same-line sketch symbol-coord-start symbol-coord-end)))
                        
    (printf "\n\n=================\n")
    (if (sat? sol-same) 
            (begin 
                (printf "solution:\n")
                (print-forms sol-same))
            (begin
                (printf "no solution found\n")))
)

(do-synthesis sk-sameline)
;TODO it would also be nice to use a constat for this function and easily change what sketch gets passed at the top 

;sk-sameline

#|solution:
/Users/serene/Projects/pippisynth/synthesis-protype/looping-synthesis.rkt:134:0
'(define (sk-sameline coord-start coord-end)
   (define coord-curr coord-start)
   (for-loop
    7
    (lambda () (same-y coord-curr coord-end))
    (lambda () (set! coord-curr coord-curr)))
   (for-loop
    7
    (lambda () (same-y coord-curr coord-end))
    (lambda () (set! coord-curr (moveDown coord-curr))))
   coord-curr)
|#


;sk-meet
#|
SOLUTION:

(define (sk-meet coord-start coord-end)
   (define coord-curr coord-start)
   (for-loop
    7
    (lambda () (same-x coord-curr coord-end))
    (lambda () (set! coord-curr (moveRight coord-curr))))
   (for-loop
    7
    (lambda () (same-y coord-curr coord-end))
    (lambda () (set! coord-curr (moveDown coord-curr))))
   coord-curr)

|#