; this file illustrates
;    - synthesis of conditionals that prevent ther character from stepping outside the board
;    - preconditions that need to be satisfied so that a solution exists for a given spec and sketch. 

#lang rosette/safe      ; stick with the safe subset for now (it's much less surprising) 
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

(define top-row 0)  ; x coordinate of the top row
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
    (< y top-row)
    ))

(define-grammar (conditional coord)
  [expr
   (choose #f
           #t
           (is-at-top coord)
           )])

(define-symbolic c boolean?)
(define (ex1-sketch coord depth)
  (set! coord (if (conditional coord) coord (moving coord   #:depth 1)))
  (assert (not (is-out-of-bounds coord)))
  
  (set! coord (if (conditional coord) coord (moving coord   #:depth 1)))
  (assert (not (is-out-of-bounds coord)))
  
  (set! coord (if (conditional coord) coord (moving coord   #:depth 1)))
  (assert (not (is-out-of-bounds coord)))
  
  (set! coord (if (conditional coord) coord (moving coord   #:depth 1)))
  (assert (not (is-out-of-bounds coord)))
  
  coord
  )

(define (fresh-sym-coord) 
  (define-symbolic* x y integer?)   ; note the '*' in define-symbolic*
  (list x y))

(define symbol-coord (fresh-sym-coord))

(define sol-same
   (synthesize
         #:forall symbol-coord
         #:guarantee (assert (implies (>= (list-ref symbol-coord 1) 1)  ; we want a solution only when we start in a row that satisfies this precondition (play with this constant) 
                                      ((curry check-diag-n 1) 0 ex1-sketch symbol-coord)))))
(if (sat? sol-same)
        (begin 
            (printf "solution:\n")
            (print-forms sol-same))
        (begin
            (printf "no solution found\n")))

#|
solution:
/Users/bodik/Documents/GitHub/pippisynth/synthesis-protype/experiment-while-if.rkt:37:0
'(define (ex1-sketch coord depth)
   (set! coord (if #f coord (moveUp coord)))
   (assert (not (is-out-of-bounds coord)))
   (set! coord (if (is-at-top coord) coord (moveUp coord)))
   (assert (not (is-out-of-bounds coord)))
   (set! coord (if (is-at-top coord) coord (moveLeft coord)))
   (assert (not (is-out-of-bounds coord)))
   (set! coord (if #f coord (moveDown coord)))
   (assert (not (is-out-of-bounds coord)))
   coord)
|#