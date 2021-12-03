;TODO add description file top 

#lang rosette/safe

(require
  rosette/lib/synthax
  rosette/lib/destruct
)

; (require racket/match); (require rosette/lib/angelic)    ; for choose*
; (output-smt #t)
; (require racket/pretty)
; (error-print-width 10000000000)
(require 
  "moving-grammar.rkt" 
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


; TODO: procedures moveLeft etc should include assertions that fail the program if the
;       move brings the character outside the board. 

(define (sk1 coord)
  ; This will synthesize to up to four move statements. Implemented via a 
  ; chaining of four depth-1 grammars (recall these were much faster
  ; than 1 depth-4 grammar)
  (moving (moving (moving (moving coord #:depth 1) #:depth 1) #:depth 1) #:depth 1))

; sk1 synthesized to move 2 up, 2 right:
(define (sol1 coord) (moveUp (moveRight (moveRight (moveUp coord)))))

(define (sk1-1 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  (define coord3 (moving coord2   #:depth 1)) 
  (define coord4 (moving coord3   #:depth 1)) 
  coord4
)

; Sketch 2: loops

(define (sol2 coord)
  ; the loop updates the parameter coord, which we return at the end of sol2
  (for-loop 2 
    (lambda () (is-out-of-bounds coord))
    (lambda () (set! coord (moveUp (moveRight (moveRight (moveUp coord)))))))
  coord)

; run the manually written program 
(displayln (sol2 '(1 2)))

; turn sol2 into a sketch (here, we just drill a grammar hole into the body of the loop 
(define (sk2 coord)
  (for-loop 2
            (lambda () (is-out-of-bounds coord))
            (lambda () (set! coord (sk1-1 coord))))
  coord)

;
; Solver 
;

(define symbol-coord (fresh-sym-coord))

(define sol-same
   (synthesize
        #:forall symbol-coord
        #:guarantee (assert
                     (implies
                      (>= (coord-y symbol-coord) 3)  ; we want a solution only when we start in a row that satisfies this precondition (play with check-diag constant) 
                      (coord-equals (coord-add '(4 -4) symbol-coord)
                                    (sk2 symbol-coord))))))

(if (sat? sol-same)
        (begin 
            (printf "solution:\n")
            (print-forms sol-same))
        (begin
            (printf "no solution found\n")))

#|
solution with y condition:
solution:
/Users/st3f/Projects/pippisynth/synthesis-protype/while_experiment.rkt:40:0
'(define (ex2-sketch coord depth)
   (for/last ((i 20)) #:break (is-out-of-bounds coord) i)
   (set! coord (moveLeft (moveUp (moveLeft (moveUp coord)))))
   coord)
|#
