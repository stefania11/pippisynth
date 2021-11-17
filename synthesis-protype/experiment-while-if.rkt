; this file illustrates
;    - synthesis of conditionals that prevent ther character from stepping outside the board
;    - preconditions that need to be satisfied so that a solution exists for a given spec and sketch. 
#lang rosette     ; loop sketch won't work if safe
(require rosette/lib/synthax)     ; Require the sketching library.
; (require racket/match); (require rosette/lib/angelic)    ; for choose*
; (output-smt #t)
; (require racket/pretty)
; (error-print-width 10000000000)
(require 
  "moving-grammar.rkt" 
  "moving-checker.rkt"
  "iterative-deepening.rkt"
)

(define top-row 0)  ; y coordinate of the top row
; true if the coordinate is in the top row 
(define (is-at-top coord)
  (let ([x (list-ref coord 0)]
        [y (list-ref coord 1)])
    (= y top-row)
    ))
; true if coord is outside (only checks the top)
(define (is-out-of-bounds coord)
  (let ([x (list-ref coord 0)]
        [y (list-ref coord 1)])
    (< y top-row)))

(define-symbolic c boolean?)

(define-grammar (conditional coord)
  [expr
   (choose #f
           #t
           (is-at-top coord)
           )])

(define (ex2-sketch coord depth)
  (for/last ([i 20]) ; play with this value to control upper bound
      #:break (is-out-of-bounds coord) i)
      (set! coord (moving coord #:depth 4))
    coord) 

(define (ex1-sketch coord depth)
  (set! coord (if (conditional coord) coord (moving coord   #:depth 1)))
  (assert (not (is-out-of-bounds coord)))
  
  (set! coord (if (conditional coord) coord (moving coord   #:depth 1)))
  (assert (not (is-out-of-bounds coord)))
  
  (set! coord (if (conditional coord) coord (moving coord   #:depth 1)))
  (assert (not (is-out-of-bounds coord)))
  
  (set! coord (if (conditional coord) coord (moving coord   #:depth 1)))
  (assert (not (is-out-of-bounds coord)))

  (set! coord (if (conditional coord) coord (moving coord   #:depth 1)))
  (assert (not (is-out-of-bounds coord)))

  (set! coord (if (conditional coord) coord (moving coord   #:depth 1)))
  (assert (not (is-out-of-bounds coord)))
  
  coord ;gives symbolic coordinates after 6 potential motion commands
  )

(define (fresh-sym-coord) 
  (define-symbolic* x y integer?)   ; note the '*' in define-symbolic*
  (list x y))

(define symbol-coord (fresh-sym-coord))

(define sol-same
   (synthesize
        #:forall symbol-coord
        #:guarantee (assert (implies (>= (car (cdr symbol-coord)) 1)  ; we want a solution only when we start in a row that satisfies this precondition (play with check-diag constant) 
                                      ((curry check-diag-n 2) 0 ex2-sketch symbol-coord))))) 
(if (sat? sol-same)
        (begin 
            (printf "solution:\n")
            (print-forms sol-same))
        (begin
            (printf "no solution found\n")))

#|
solution:
/Users/st3f/Projects/pippisynth/synthesis-protype/while_experiment.rkt:40:0
'(define (ex2-sketch coord depth)
   (for/last ((i 20)) #:break (is-out-of-bounds coord) i)
   (set! coord (moveLeft (moveUp (moveLeft (moveUp coord)))))
   coord)
|#