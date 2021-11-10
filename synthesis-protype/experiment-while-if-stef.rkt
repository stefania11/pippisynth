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
                                      ((curry check-diag-n 1) 0 ex1-sketch symbol-coord))))); depth is 0, checking for a diagonal 
(if (sat? sol-same)
        (begin 
            (printf "solution:\n")
            (print-forms sol-same))
        (begin
            (printf "no solution found\n")))


#|
solution with y condition:
solution:
/Users/st3f/Projects/pippisynth/synthesis-protype/experiment-while-if-stef.rkt:35:0
'(define (ex1-sketch coord depth)
   (set! coord (if (is-at-top coord) coord (moveLeft coord)))
   (assert (not (is-out-of-bounds coord)))
   (set! coord (if (is-at-top coord) coord (moveUp coord)))
   (assert (not (is-out-of-bounds coord)))
   (set! coord (if #t coord (moveRight (assert #f))))
   (assert (not (is-out-of-bounds coord)))
   (set! coord (if #t coord (moveRight (assert #f))))
   (assert (not (is-out-of-bounds coord)))
   (set! coord (if #t coord (moveRight (assert #f))))
   (assert (not (is-out-of-bounds coord)))
   (set! coord (if #t coord (moveRight (assert #f))))
   (assert (not (is-out-of-bounds coord)))
   coord)
|#