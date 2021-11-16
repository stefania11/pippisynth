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


; -------------------------------------------------------------
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

(define after4 (current-inexact-milliseconds))
(define time4 (- after4 before4))
(set! outer-string (string-append outer-string "emina,4,"))
(set! outer-string (string-append outer-string (~s time4)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog4 sol4))))
(set! outer-string (string-append outer-string "\n"))


; -------------------------------------------------------------
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

(define after6 (current-inexact-milliseconds))
(define time6 (- after6 before6))
(set! outer-string (string-append outer-string "emina,6,"))
(set! outer-string (string-append outer-string (~s time6)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog6 sol6))))
(set! outer-string (string-append outer-string "\n"))


; -------------------------------------------------------------
(define prog8 (list
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
  (sym-op)
)) 

(define before8 (current-inexact-milliseconds))
(define sol8
  (synthesize
     #:forall in
     #:guarantee
     (let ([out (interpret prog8 in)])
       (assert (= (point-x out) (- (point-x in) 4)))
       (assert (= (point-y out) (- (point-y in) 4))))))

(define after8 (current-inexact-milliseconds))
(define time8 (- after8 before8))
(set! outer-string (string-append outer-string "emina,8,"))
(set! outer-string (string-append outer-string (~s time8)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog8 sol8))))
(set! outer-string (string-append outer-string "\n"))


; -------------------------------------------------------------
(define prog10 (list
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

(define before10 (current-inexact-milliseconds))
(define sol10
  (synthesize
     #:forall in
     #:guarantee
     (let ([out (interpret prog10 in)])
       (assert (= (point-x out) (- (point-x in) 5)))
       (assert (= (point-y out) (- (point-y in) 5))))))

(define after10 (current-inexact-milliseconds))
(define time10 (- after10 before10))
(set! outer-string (string-append outer-string "emina,10,"))
(set! outer-string (string-append outer-string (~s time10)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog10 sol10))))
(set! outer-string (string-append outer-string "\n"))


; -------------------------------------------------------------
(define prog12 (list
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

(define before12 (current-inexact-milliseconds))
(define sol12
  (synthesize
     #:forall in
     #:guarantee
     (let ([out (interpret prog12 in)])
       (assert (= (point-x out) (- (point-x in) 6)))
       (assert (= (point-y out) (- (point-y in) 6))))))

(define after12 (current-inexact-milliseconds))
(define time12 (- after12 before12))
(set! outer-string (string-append outer-string "emina,12,"))
(set! outer-string (string-append outer-string (~s time12)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog12 sol12))))
(set! outer-string (string-append outer-string "\n"))


; -------------------------------------------------------------
(define prog14 (list
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

(define before14 (current-inexact-milliseconds))
(define sol14
  (synthesize
     #:forall in
     #:guarantee
     (let ([out (interpret prog14 in)])
       (assert (= (point-x out) (- (point-x in) 7)))
       (assert (= (point-y out) (- (point-y in) 7))))))

(define after14 (current-inexact-milliseconds))
(define time14 (- after14 before14))
(set! outer-string (string-append outer-string "emina,14,"))
(set! outer-string (string-append outer-string (~s time14)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog14 sol14))))
(set! outer-string (string-append outer-string "\n"))


; -------------------------------------------------------------
(define prog16 (list
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

(define before16 (current-inexact-milliseconds))
(define sol16
  (synthesize
     #:forall in
     #:guarantee
     (let ([out (interpret prog16 in)])
       (assert (= (point-x out) (- (point-x in) 8)))
       (assert (= (point-y out) (- (point-y in) 8))))))

(define after16 (current-inexact-milliseconds))
(define time16 (- after16 before16))
(set! outer-string (string-append outer-string "emina,16,"))
(set! outer-string (string-append outer-string (~s time16)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog16 sol16))))
(set! outer-string (string-append outer-string "\n"))


; -------------------------------------------------------------
(define prog18 (list
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

(define before18 (current-inexact-milliseconds))
(define sol18
  (synthesize
     #:forall in
     #:guarantee
     (let ([out (interpret prog18 in)])
       (assert (= (point-x out) (- (point-x in) 9)))
       (assert (= (point-y out) (- (point-y in) 9))))))

(define after18 (current-inexact-milliseconds))
(define time18 (- after18 before18))
(set! outer-string (string-append outer-string "emina,18,"))
(set! outer-string (string-append outer-string (~s time18)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog18 sol18))))
(set! outer-string (string-append outer-string "\n"))


; -------------------------------------------------------------
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
