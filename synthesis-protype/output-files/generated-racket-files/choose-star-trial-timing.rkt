#lang rosette
(require rosette/lib/synthax)     ; Require the sketching library.
(require racket/match)
(require 2htdp/batch-io)
(error-print-width 10000000000)
(require racket/sandbox)
(require rosette/lib/angelic)

(define-symbolic* x y integer?) 
(define symbol-coord (list x y))


(define (checker n impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x n) new-x))
     (assert (= (- y n) new-y))]))

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

(define outer-string "")
(set! outer-string (string-append outer-string "type,size,time,program\n"))


; ------------------ 
(printf "\n\nprog 2 choose-star way: \n")
(define (prog-sketch2 coord0)
  (define coord1 (moving-star coord0)) 
  (define coord2 (moving-star coord1)) 
  coord2
)
(define before2 (current-inexact-milliseconds))

(define sol2
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 1) prog-sketch2 symbol-coord)))


(define after2 (current-inexact-milliseconds))
(define time2 (- after2 before2))
(set! outer-string (string-append outer-string "choose-star,2,"))
(set! outer-string (string-append outer-string (~s time2)))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 4 choose-star way: \n")
(define (prog-sketch4 coord0)
  (define coord1 (moving-star coord0)) 
  (define coord2 (moving-star coord1)) 
  (define coord3 (moving-star coord2)) 
  (define coord4 (moving-star coord3)) 
  coord4
)
(define before4 (current-inexact-milliseconds))

(define sol4
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 2) prog-sketch4 symbol-coord)))


(define after4 (current-inexact-milliseconds))
(define time4 (- after4 before4))
(set! outer-string (string-append outer-string "choose-star,4,"))
(set! outer-string (string-append outer-string (~s time4)))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 6 choose-star way: \n")
(define (prog-sketch6 coord0)
  (define coord1 (moving-star coord0)) 
  (define coord2 (moving-star coord1)) 
  (define coord3 (moving-star coord2)) 
  (define coord4 (moving-star coord3)) 
  (define coord5 (moving-star coord4)) 
  (define coord6 (moving-star coord5)) 
  coord6
)
(define before6 (current-inexact-milliseconds))

(define sol6
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 3) prog-sketch6 symbol-coord)))


(define after6 (current-inexact-milliseconds))
(define time6 (- after6 before6))
(set! outer-string (string-append outer-string "choose-star,6,"))
(set! outer-string (string-append outer-string (~s time6)))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 8 choose-star way: \n")
(define (prog-sketch8 coord0)
  (define coord1 (moving-star coord0)) 
  (define coord2 (moving-star coord1)) 
  (define coord3 (moving-star coord2)) 
  (define coord4 (moving-star coord3)) 
  (define coord5 (moving-star coord4)) 
  (define coord6 (moving-star coord5)) 
  (define coord7 (moving-star coord6)) 
  (define coord8 (moving-star coord7)) 
  coord8
)
(define before8 (current-inexact-milliseconds))

(define sol8
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 4) prog-sketch8 symbol-coord)))


(define after8 (current-inexact-milliseconds))
(define time8 (- after8 before8))
(set! outer-string (string-append outer-string "choose-star,8,"))
(set! outer-string (string-append outer-string (~s time8)))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 10 choose-star way: \n")
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
(define before10 (current-inexact-milliseconds))

(define sol10
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 5) prog-sketch10 symbol-coord)))


(define after10 (current-inexact-milliseconds))
(define time10 (- after10 before10))
(set! outer-string (string-append outer-string "choose-star,10,"))
(set! outer-string (string-append outer-string (~s time10)))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 12 choose-star way: \n")
(define (prog-sketch12 coord0)
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
  (define coord11 (moving-star coord10)) 
  (define coord12 (moving-star coord11)) 
  coord12
)
(define before12 (current-inexact-milliseconds))

(define sol12
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 6) prog-sketch12 symbol-coord)))


(define after12 (current-inexact-milliseconds))
(define time12 (- after12 before12))
(set! outer-string (string-append outer-string "choose-star,12,"))
(set! outer-string (string-append outer-string (~s time12)))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 14 choose-star way: \n")
(define (prog-sketch14 coord0)
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
  (define coord11 (moving-star coord10)) 
  (define coord12 (moving-star coord11)) 
  (define coord13 (moving-star coord12)) 
  (define coord14 (moving-star coord13)) 
  coord14
)
(define before14 (current-inexact-milliseconds))

(define sol14
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 7) prog-sketch14 symbol-coord)))


(define after14 (current-inexact-milliseconds))
(define time14 (- after14 before14))
(set! outer-string (string-append outer-string "choose-star,14,"))
(set! outer-string (string-append outer-string (~s time14)))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 16 choose-star way: \n")
(define (prog-sketch16 coord0)
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
  (define coord11 (moving-star coord10)) 
  (define coord12 (moving-star coord11)) 
  (define coord13 (moving-star coord12)) 
  (define coord14 (moving-star coord13)) 
  (define coord15 (moving-star coord14)) 
  (define coord16 (moving-star coord15)) 
  coord16
)
(define before16 (current-inexact-milliseconds))

(define sol16
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 8) prog-sketch16 symbol-coord)))


(define after16 (current-inexact-milliseconds))
(define time16 (- after16 before16))
(set! outer-string (string-append outer-string "choose-star,16,"))
(set! outer-string (string-append outer-string (~s time16)))
(set! outer-string (string-append outer-string "\n"))


; ------------------ 
(printf "\n\nprog 18 choose-star way: \n")
(define (prog-sketch18 coord0)
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
  (define coord11 (moving-star coord10)) 
  (define coord12 (moving-star coord11)) 
  (define coord13 (moving-star coord12)) 
  (define coord14 (moving-star coord13)) 
  (define coord15 (moving-star coord14)) 
  (define coord16 (moving-star coord15)) 
  (define coord17 (moving-star coord16)) 
  (define coord18 (moving-star coord17)) 
  coord18
)
(define before18 (current-inexact-milliseconds))

(define sol18
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 9) prog-sketch18 symbol-coord)))


(define after18 (current-inexact-milliseconds))
(define time18 (- after18 before18))
(set! outer-string (string-append outer-string "choose-star,18,"))
(set! outer-string (string-append outer-string (~s time18)))
(set! outer-string (string-append outer-string "\n"))
(write-file "output-files/timing-output/choose-star-timing.csv" outer-string)
