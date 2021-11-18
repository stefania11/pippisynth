#lang rosette
; #lang rosette/safe

(require
  rosette/lib/synthax
  rosette/lib/destruct
)

(require 
  "moving-grammar.rkt" 
)

(require 2htdp/batch-io)


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
  (define-symbolic* x y integer?)   ; note the '*' in define-symbolic*
  (list x y))

(define (coord-equals coord coord2)
  (destruct (append coord coord2)
    [(list x y x2 y2)
     (and (= x x2)
          (= y y2))]))

(define (coord-x coord)
  (list-ref coord 0))

(define (coord-y coord)
  (list-ref coord 1))

(define (coord-add coord coord2)
  (destruct (append coord coord2)
    [(list x y x2 y2)
     (list (+ x x2)
           (+ y y2))]))


;
; Various board position predicates 
;

(define top-row 0)  ; y coordinate of the top row
(define bottom-row 250)
(define left-col 0)
(define right-col 250)

; difference here is that we're checking if it is AT the bounds
;  instead of already outside the bounds
(define (is-at-bounds coord)
  (destruct coord
    [(list x y) (or 
        (= y top-row)
        (= y bottom-row)
        (= x left-col)
        (= x right-col)
    )]))


;
; SKETCHES
;

(define (sk1 coord)
  (moving (moving coord #:depth 1) #:depth 1))

(define (sk2 coord)
  (moving (moving (moving (moving coord #:depth 1) #:depth 1) #:depth 1) #:depth 1))

(define (sk3 coord)
  (moving (moving (moving (moving (moving (moving (moving (moving coord #:depth 1) #:depth 1) #:depth 1) #:depth 1) #:depth 1) #:depth 1) #:depth 1) #:depth 1))


(define (sk4 coord)
  ; the loop updates the parameter coord, which we return at the end of sk3
  (for-loop 4
    (lambda () (is-at-bounds coord))
    (lambda () (set! coord sk1)))
  coord)

(define (sk5 coord)
  ; the loop updates the parameter coord, which we return at the end of sol2
  (for-loop 2
    (lambda () (is-at-bounds coord))
    (lambda () (set! coord sk2)))
  coord)

(define (sk6 coord)
  ; the loop updates the parameter coord, which we return at the end of sk3
  (for-loop 1
    (lambda () (is-at-bounds coord))
    (lambda () (set! coord sk3)))
  coord)


; Solver stuff
;

(define (doSynthesis sketch difference)

    (define symbol-coord (fresh-sym-coord))

    (define before (current-inexact-milliseconds))
    (define sol-same
    (synthesize
            #:forall symbol-coord
            #:guarantee (assert
                        (implies (and 
                            true
                            ; (>= (coord-y symbol-coord) 6)
                            ; (>= (coord-x symbol-coord) 6)
                            ; (<= (coord-x symbol-coord) 240)
                            ; (<= (coord-y symbol-coord) 240)
                            )
                        (coord-equals (coord-add difference symbol-coord)
                                        (sketch symbol-coord))))))
    (define after (current-inexact-milliseconds))
    (define time (- after before))
    (printf "\n\n=================\n")
    (if (sat? sol-same) 
            (begin 
                (printf "solution:\n")
                (print-forms sol-same))
            (begin
                (printf "no solution found\n")))
    (printf "\n***** time: ~s milliseconds\n" time)
)

(doSynthesis sk1 '(1 -1))
(doSynthesis sk2 '(2 -2))
(doSynthesis sk3 '(4 -4))

(doSynthesis sk4 '(4 -4))
(doSynthesis sk5 '(4 -4))
(doSynthesis sk6 '(4 -4))






