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

; call the custom for loop 
(define cnt 0)
(for-loop 5
          (lambda () (= 3 cnt))
          (lambda () (set! cnt (add1 cnt)) (display cnt)))
; outputs 123'()

;
; Coordinate stuff
;

(define (fresh-sym-coord) 
  (define-symbolic* x y integer?)   ; note the '*' in define-symbolic*
  (list x y))

(define (coord-equals coord coord2)
  (destruct (append coord coord2)
    [(list x y x2 y2)
     (and (= x x2)
          (= y y2))]))

(define (coord-y coord)
  (list-ref coord 1))

(define (coord-add coord coord2)
  (destruct (append coord coord2)
    [(list x y x2 y2)
     (list (+ x x2)
           (+ y y2))]))

; (coord-equals '(1 3) '(1 2))

;
; Various board position predicates 
;

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


(define-grammar (conditional coord)
  [expr
   (choose #f
           #t
           (is-at-top coord)
           )])

; TODO: procedures moveLeft etc should include assertions that fail the program if the
;       move brings the character outside the board.

(define (sk1 coord)
  ; This will synthesize to up to four move statements. Implemented via a 
  ; chaining of four depth-1 grammars (recall these were much faster
  ; than 1 depth-4 grammar)
  (moving (moving (moving (moving coord #:depth 1) #:depth 1) #:depth 1) #:depth 1))

; ssk1 ynthesized to move 2 up, 2 right:
(define (sol1 coord) (moveUp (moveRight (moveRight (moveUp coord)))))


; sketch 2: loops

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
            (lambda () (set! coord (sk1 coord))))
  coord)

;
; Solver stuff
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
