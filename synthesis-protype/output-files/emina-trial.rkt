#lang rosette

(require rosette/lib/angelic rosette/lib/destruct)
(require 2htdp/batch-io)

(struct point (x y) #:transparent)

(define (moveUp coord)
  (destruct coord
    [(point x y) (point x (- y 1))]))

(define (moveDown coord)
  (destruct coord
    [(point x y) (point x (+ y 1))]))

(define (moveLeft coord)
  (destruct coord
    [(point x y) (point (- x 1) y)]))

(define (moveRight coord)
  (destruct coord
    [(point x y) (point (+ x 1) y)]))

(define (nop coord) coord)

; Deep embedding where operators are the functions
; nop, moveUp, moveDown, moveLeft, moveRight.
(define (interpret ops coord)
  (if (null? ops)
      coord
      (interpret (cdr ops) ((car ops) coord))))

; Now, synthesizing a program involves picking a list of
; functions rather than having to construct a nested expression.
(define (sym-op)
  (choose*
   nop moveUp moveDown
   moveLeft moveRight))

(define-symbolic* x y integer?)
(define in (point x y))

(define outer-string "")
(set! outer-string (string-append outer-string "type,size,time,program\n"))
(define prog20 (list
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
)) 

(define before20 (current-inexact-milliseconds))
(define sol20
  (synthesize
     #:forall in
     #:guarantee
     (let ([out (interpret prog20 in)])
       (assert (= (point-x out) (- (point-x in) 10)))
       (assert (= (point-y out) (- (point-y in) 10))))))

(define after20 (current-inexact-milliseconds))
(define time20 (- after20 before20))
(set! outer-string (string-append outer-string "emina,20,"))
(set! outer-string (string-append outer-string (~s time20)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog20 sol20))))
(set! outer-string (string-append outer-string "\n"))
(write-file "output-files/emina.csv" outer-string)
