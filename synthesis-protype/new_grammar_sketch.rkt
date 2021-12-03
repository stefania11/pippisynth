#lang rosette/safe

(require
  rosette/lib/synthax
  rosette/lib/destruct
)

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

(define (same-x coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (= x1 x2)]))

(define (same-y coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (= y1 y2)]))

;
; Conditional grammar (new!!)
;

(define-grammar (bi-conditional coord1 coord2)
    [expr
        (choose (same-x coord1 coord2)
                (same-y coord1 coord2)
        )
    ]
)

;
; Various board position predicates 
;

(define top-row 0)
(define bottom-row 250)
(define left-col 0)
(define right-col 250)

; (new!!) different than `is-out-of-bounds`
;   difference here is that we're checking if it is AT the bounds
;   instead of already outside the bounds
;   I (darya) find this to be a better checker 
;   (we want to stop AT bounds, not once we're already outside them)
;   THIS ISN'T USED BUT I WANTED TO INCLUDE FOR FURTHER EXPLORATION
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

(define (sk-meet coord-start coord-end)
  (define coord-curr coord-start)
  (for-loop 7
    (lambda () (bi-conditional coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  (for-loop 7
    (lambda () (bi-conditional coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  coord-curr
)

;
; CHECKERS
;

(define (checker-same-bi impl coord-start coord-end)
  (destruct (append coord-start coord-end)
    [(list x1 y1 x2 y2)

     (define new-coord (impl coord-start coord-end))

     (assert (implies 
                (and
                    ; this is saying that (x2-7) <= x1 <= x2
                    (<= x1 x2)
                    (>= x1 (- x2 7))

                    ; this is saying that (y2-7) <= y1 <= y2
                    (<= y1 y2)
                    (>= y1 (- y2 7))
                )
                (coord-equals new-coord coord-end)
             ))
    ]
  )
)

;
; SOLVERS
;

(define (do-synthesis-bi sketch)

    (define symbol-coord-start (fresh-sym-coord))
    (define symbol-coord-end   (fresh-sym-coord))

    (define sol-same
      (synthesize
              #:forall (list symbol-coord-start symbol-coord-end)
              #:guarantee (checker-same-bi sketch symbol-coord-start symbol-coord-end)))
                        
    (printf "\n\n=================\n")
    (if (sat? sol-same) 
            (begin 
                (printf "solution:\n")
                (print-forms sol-same))
            (begin
                (printf "no solution found\n")))
)

(do-synthesis-bi sk-meet)

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