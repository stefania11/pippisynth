#lang rosette

(require racket/pretty)
(error-print-width 10000000)

(require rosette/lib/angelic)
(require rosette/lib/synthax)

; DEFINITIONS
(define (moveLeft coord)
  (match coord
    [(list x y) (list (- x 1) y)]))

(define (moveRight coord)
  (match coord
    [(list x y) (list (+ x 1) y)]))

(define (moveUp coord)
  (match coord
    [(list x y) (list x (- y 1))]))

(define (moveDown coord)
  (match coord
    [(list x y) (list x (+ y 1))]))

(define (nop coord) coord)

(define (moving-star coord)
   (choose* coord
            (moveUp coord)
            (moveRight coord)
            (moveLeft coord)
            (moveDown coord)))

(define (checker n impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x n) new-x))
     (assert (= (- y n) new-y))]))

; CHECKER
; (define (checker-same impl coord)
;   (match coord
;     [(list x y)
;      (define new-coord (impl coord))
;      (define new-x (list-ref new-coord 0))
;      (define new-y (list-ref new-coord 1))
;      (assert (= x new-x))
;      (assert (= y new-y))]))

(define-symbolic* x y integer?) 
(define symbol-coord (list x y))


; ------------------ 
; (printf "\n\n========\nprogr-sketch1: \n")
; (define (prog-sketch1 coord0)
;   (define coord1 ((curry mov) coord0)) 
;   coord1
; )

; (define sol1
;   (synthesize
;       #:forall symbol-coord
;       #:guarantee (checker-same prog-sketch1 symbol-coord)))

; (printf "\n   * (displayln sol1):\n")
; (displayln sol1)

; (printf "\n   * (evaluate prog-sketch1 sol1):\n")
; (evaluate prog-sketch1 sol1)

; (printf "\n   * (generate-forms sol1):\n")
; (generate-forms sol1)

; (printf "\n   * (print-forms sol1):\n")
; (print-forms sol1)

; ------------------ 
; (printf "\n\n========\nprogr-sketch2: \n")
(define (prog-sketch10 coord0)
  (define coord1 (moving-star coord0)) 
  (define coord2 (moving-star coord1)) 
  (define coord3 (moving-star coord2)) 
  (define coord4 (moving-star coord3)) 
  (define coord5 (moving-star coord4)) 
  (define coord6 (moving-star coord5)) 
  (define coord7 (moving-star coord6)) 
  (define coord8 (moving-star coord7)) 
  (define coord9 (moving-star coord8)) 
  (define coord10 (moving-star coord9)) 
  coord10
)

(define sol10
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 5) prog-sketch10 symbol-coord)))

(if (sat? sol10)
    (printf "sat!!! \n")
    (printf "unsat :( \n")
)
; (prog-sketch2 (list 55 66))
; (displayln sol2)
; (print-forms sol2)

; (evaluate prog-sketch2 sol2)
; ((evaluate prog-sketch2 sol2) symbol-coord)














; (define moving-star
;    (choose* nop
;             moveUp
;             moveRight
;             moveLeft
;             moveDown))

; ((mov) coord)