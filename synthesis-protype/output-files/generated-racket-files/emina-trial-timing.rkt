#lang rosette

(require rosette/lib/angelic rosette/lib/destruct)
(require 2htdp/batch-io)
(require racket/sandbox)

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


; ------------------ 
(printf "\n\nprog 2 emina way: \n")
(define prog2 (list
  (sym-op)
  (sym-op)
)) 

(define before2 (current-inexact-milliseconds))
(define sol2
  (synthesize
     #:forall in
     #:guarantee
     (let ([out (interpret prog2 in)])
       (assert (= (point-x out) (- (point-x in) 1)))
       (assert (= (point-y out) (- (point-y in) 1))))))

(evaluate prog2 sol2)
(define after2 (current-inexact-milliseconds))
(define time2 (- after2 before2))
(set! outer-string (string-append outer-string "emina,2,"))
(set! outer-string (string-append outer-string (~s time2)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog2 sol2))))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 4 emina way: \n")
(define prog4 (list
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
)) 

(define before4 (current-inexact-milliseconds))
(define sol4
  (synthesize
     #:forall in
     #:guarantee
     (let ([out (interpret prog4 in)])
       (assert (= (point-x out) (- (point-x in) 2)))
       (assert (= (point-y out) (- (point-y in) 2))))))

(evaluate prog4 sol4)
(define after4 (current-inexact-milliseconds))
(define time4 (- after4 before4))
(set! outer-string (string-append outer-string "emina,4,"))
(set! outer-string (string-append outer-string (~s time4)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog4 sol4))))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 6 emina way: \n")
(define prog6 (list
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
)) 

(define before6 (current-inexact-milliseconds))
(define sol6
  (synthesize
     #:forall in
     #:guarantee
     (let ([out (interpret prog6 in)])
       (assert (= (point-x out) (- (point-x in) 3)))
       (assert (= (point-y out) (- (point-y in) 3))))))

(evaluate prog6 sol6)
(define after6 (current-inexact-milliseconds))
(define time6 (- after6 before6))
(set! outer-string (string-append outer-string "emina,6,"))
(set! outer-string (string-append outer-string (~s time6)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog6 sol6))))
(set! outer-string (string-append outer-string "\n"))
(write-file "output-files/timing-output/emina-timing.csv" outer-string)
