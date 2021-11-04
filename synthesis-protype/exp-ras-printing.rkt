; this file illustrates how to write sketches so that the synthesized program is fully printed and simplified 

#lang rosette/safe      ; stick with the safe subset for now (it's much less surprising) 
(require rosette/lib/synthax)     ; Require the sketching library.
; (require racket/match);
(require rosette/lib/angelic)    ; for choose*
; (output-smt #t)
; (require racket/pretty)
; (error-print-width 10000000000)
(require 
  "moving-grammar.rkt" 
  "moving-checker.rkt"
  "iterative-deepening.rkt"
)



(define-grammar (conditional)
  [expr
   (choose #f
           #t)])

(define (program-slot coord)
  (define-symbolic* c boolean?)
  (if c coord (moving coord  #:depth 1))
  )

#;(define-syntax foo
  (syntax-rules ()
      ((_ coord)
       (begin 
       (define-symbolic* c boolean?) 
       (set! coord (if c coord (moving coord  #:depth 1)))))))

(define-syntax foo
  (syntax-rules ()
      ((_ coord)
       (set! coord (choose* coord (moving coord  #:depth 1))))))

(define-symbolic c boolean?)
(define (ex1-sketch coord depth)
  (define coord1 (if (conditional) coord (moving coord   #:depth 1)))
  (define coord2 (if c coord1 (moving coord1  #:depth 1)))
  (define coord3 (choose coord2 (moving coord2  #:depth 1)))
  (define coord4 (choose coord3 (moving coord3  #:depth 1)))
  (define coord5 (choose coord4 (moving coord4  #:depth 1)))
  (define coord6 (choose coord5 (moving coord5  #:depth 1)))
  coord6
  )

(define (ex2-sketch coord depth)
  (set! coord (program-slot coord))
  ...
  (program-slot coord)
  (program-slot coord)
  (program-slot coord)
  (program-slot coord)
  (program-slot coord)
  coord
  )

(define coord (list 1 0))
(define coord2 (list 1 0))

; (foo coord)
;(foo coord2)
; (set! coord (if c coord (moving coord  #:depth 1)))
; coord
; coord2

(ex2-sketch coord 0)

(define (ex3-sketch coord depth)
  (foo coord)
  (foo coord)
  (foo coord)
  (foo coord)
  (foo coord)
  (foo coord)
  coord
  )

(define (fresh-sym-coord) 
  (define-symbolic* x y integer?)   ; note the '*' in define-symbolic*
  (list x y))

; tests whether the coordinates have fresh symbols
; see what this expression does when you remove the '*' above
; (equal? (fresh-sym-coord) (fresh-sym-coord))

(define symbol-coord (fresh-sym-coord))

(define sol-same
   (synthesize
         #:forall symbol-coord
         #:guarantee ((curry check-diag-n 2) 0 ex2-sketch symbol-coord)))
(if (sat? sol-same)
        (begin 
            (printf "solution:\n")
            (printf "c=~e\n" (evaluate c sol-same))
            (print-forms sol-same))
        (begin
            (printf "no solution found\n")))

#|
solution:
c=#f
/Users/bodik/Documents/GitHub/pippisynth/synthesis-protype/exp-ras-printing.rkt:23:0
'(define (ex1-sketch coord depth)
   (define coord1 (if #t coord (moveRight coord)))   ; if not simplified 
   (define coord2 (if c coord1 (moveLeft coord1)))   ; symvar c not evalauted
   (define coord3 (moveUp coord2))                   ; choose's and grammars are evaluated 
   (define coord4 coord3)
   (define coord5 (moveUp coord4))
   (define coord6 (moveLeft coord5))
   coord6)
|#