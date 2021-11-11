#lang rosette/safe   ; stick with the safe subset for now (it's much less surprising) 
(require rosette/lib/synthax)     ; Require the sketching library.

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
(provide is-at-top is-out-of-bounds)

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
            ; (display (generate-forms sol-same))
            (print-forms sol-same)
            )
        (begin
            (printf "no solution found\n")))


; Running syntehsized code as Racket code

; importing these so that we can keep using rosette/safe
(require (only-in racket/base syntax->datum))
(require (only-in racket/base define-namespace-anchor namespace-anchor->namespace eval))

; Extract the syntactic form of the synthesized code
; Todo: Here we assume that there is only one procedure definition (cf. (car ...))
(define syn-code (car (generate-forms sol-same)))
; change the syntax object to a list
(define syn-code-datum (syntax->datum syn-code))

; We are going to run the code in the current namespace (hence the anchor).
; That is, functions such as is-at-top will be visible from the synthesized code.
(define-namespace-anchor a)
(define ns (namespace-anchor->namespace a)) 
(define (run code) 
  (eval code ns))

; Example usage:
; (run '(+ 1 2))
; (run '(define foo 2))
; (run '(+ foo 3))

; We need to rename the syntehsized procedure to avoid the name conflict with
; the sketch from of the procedure. 
(require lens/common)
(require lens/data/list)

; We replace just the name of the procedure
(define new-name 'ex1)
; Usage of lenses: see https://docs.racket-lang.org/lens/lens-reference.html#%28def._%28%28lib._lens%2Fdata%2Flist..rkt%29._list-ref-nested-lens%29%29
(define first-of-second-lens (list-ref-nested-lens 1 0)) ; assumes the list is '(define (proc-name ...) ...)
(define renamed-code (lens-set first-of-second-lens syn-code-datum new-name))
; (displayln renamed-code)

; This defines the syntehsized procedure 
(run renamed-code)
; Finally ready to run the synthesized code
(run '(displayln (ex1 (list 1 2) 1)))
