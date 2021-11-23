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


; ------------------ 
(printf "\n\nprog 8 emina way: \n")
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

(evaluate prog8 sol8)
(define after8 (current-inexact-milliseconds))
(define time8 (- after8 before8))
(set! outer-string (string-append outer-string "emina,8,"))
(set! outer-string (string-append outer-string (~s time8)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog8 sol8))))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 10 emina way: \n")
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

(evaluate prog10 sol10)
(define after10 (current-inexact-milliseconds))
(define time10 (- after10 before10))
(set! outer-string (string-append outer-string "emina,10,"))
(set! outer-string (string-append outer-string (~s time10)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog10 sol10))))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 12 emina way: \n")
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

(evaluate prog12 sol12)
(define after12 (current-inexact-milliseconds))
(define time12 (- after12 before12))
(set! outer-string (string-append outer-string "emina,12,"))
(set! outer-string (string-append outer-string (~s time12)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog12 sol12))))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 14 emina way: \n")
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

(evaluate prog14 sol14)
(define after14 (current-inexact-milliseconds))
(define time14 (- after14 before14))
(set! outer-string (string-append outer-string "emina,14,"))
(set! outer-string (string-append outer-string (~s time14)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog14 sol14))))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 16 emina way: \n")
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

(evaluate prog16 sol16)
(define after16 (current-inexact-milliseconds))
(define time16 (- after16 before16))
(set! outer-string (string-append outer-string "emina,16,"))
(set! outer-string (string-append outer-string (~s time16)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog16 sol16))))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 18 emina way: \n")
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

(evaluate prog18 sol18)
(define after18 (current-inexact-milliseconds))
(define time18 (- after18 before18))
(set! outer-string (string-append outer-string "emina,18,"))
(set! outer-string (string-append outer-string (~s time18)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog18 sol18))))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 20 emina way: \n")
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

(evaluate prog20 sol20)
(define after20 (current-inexact-milliseconds))
(define time20 (- after20 before20))
(set! outer-string (string-append outer-string "emina,20,"))
(set! outer-string (string-append outer-string (~s time20)))
(set! outer-string (string-append outer-string ","))
(set! outer-string (string-append outer-string (~s (evaluate prog20 sol20))))
(set! outer-string (string-append outer-string "\n"))
(write-file "output-files/timing-output/emina-timing.csv" outer-string)
