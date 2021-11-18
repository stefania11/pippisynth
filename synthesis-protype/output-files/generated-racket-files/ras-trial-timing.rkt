#lang rosette
(require rosette/lib/synthax)     ; Require the sketching library.
(require racket/match)
(require 2htdp/batch-io)
(error-print-width 10000000000)
(require 
  "../../moving-grammar.rkt"
)
(require racket/sandbox)

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

(define outer-string "")
(set! outer-string (string-append outer-string "type,size,time,program\n"))


; ------------------ 
(printf "\n\nprog 2 ras way: \n")
(define (prog-sketch2 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  coord2
)
(define before2 (current-inexact-milliseconds))

(define sol2
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 1) prog-sketch2 symbol-coord)))


(define after2 (current-inexact-milliseconds))
(define time2 (- after2 before2))
(set! outer-string (string-append outer-string "ras,2,"))
(set! outer-string (string-append outer-string (~s time2)))
(set! outer-string (string-append outer-string "\n"))
(print-forms sol2)


; ------------------ 
(printf "\n\nprog 4 ras way: \n")
(define (prog-sketch4 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  (define coord3 (moving coord2   #:depth 1)) 
  (define coord4 (moving coord3   #:depth 1)) 
  coord4
)
(define before4 (current-inexact-milliseconds))

(define sol4
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 2) prog-sketch4 symbol-coord)))


(define after4 (current-inexact-milliseconds))
(define time4 (- after4 before4))
(set! outer-string (string-append outer-string "ras,4,"))
(set! outer-string (string-append outer-string (~s time4)))
(set! outer-string (string-append outer-string "\n"))
(print-forms sol4)


; ------------------ 
(printf "\n\nprog 6 ras way: \n")
(define (prog-sketch6 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  (define coord3 (moving coord2   #:depth 1)) 
  (define coord4 (moving coord3   #:depth 1)) 
  (define coord5 (moving coord4   #:depth 1)) 
  (define coord6 (moving coord5   #:depth 1)) 
  coord6
)
(define before6 (current-inexact-milliseconds))

(define sol6
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 3) prog-sketch6 symbol-coord)))


(define after6 (current-inexact-milliseconds))
(define time6 (- after6 before6))
(set! outer-string (string-append outer-string "ras,6,"))
(set! outer-string (string-append outer-string (~s time6)))
(set! outer-string (string-append outer-string "\n"))
(print-forms sol6)


; ------------------ 
(printf "\n\nprog 8 ras way: \n")
(define (prog-sketch8 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  (define coord3 (moving coord2   #:depth 1)) 
  (define coord4 (moving coord3   #:depth 1)) 
  (define coord5 (moving coord4   #:depth 1)) 
  (define coord6 (moving coord5   #:depth 1)) 
  (define coord7 (moving coord6   #:depth 1)) 
  (define coord8 (moving coord7   #:depth 1)) 
  coord8
)
(define before8 (current-inexact-milliseconds))

(define sol8
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 4) prog-sketch8 symbol-coord)))


(define after8 (current-inexact-milliseconds))
(define time8 (- after8 before8))
(set! outer-string (string-append outer-string "ras,8,"))
(set! outer-string (string-append outer-string (~s time8)))
(set! outer-string (string-append outer-string "\n"))
(print-forms sol8)


; ------------------ 
(printf "\n\nprog 10 ras way: \n")
(define (prog-sketch10 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  (define coord3 (moving coord2   #:depth 1)) 
  (define coord4 (moving coord3   #:depth 1)) 
  (define coord5 (moving coord4   #:depth 1)) 
  (define coord6 (moving coord5   #:depth 1)) 
  (define coord7 (moving coord6   #:depth 1)) 
  (define coord8 (moving coord7   #:depth 1)) 
  (define coord9 (moving coord8   #:depth 1)) 
  (define coord10 (moving coord9   #:depth 1)) 
  coord10
)
(define before10 (current-inexact-milliseconds))

(define sol10
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 5) prog-sketch10 symbol-coord)))


(define after10 (current-inexact-milliseconds))
(define time10 (- after10 before10))
(set! outer-string (string-append outer-string "ras,10,"))
(set! outer-string (string-append outer-string (~s time10)))
(set! outer-string (string-append outer-string "\n"))
(print-forms sol10)


; ------------------ 
(printf "\n\nprog 12 ras way: \n")
(define (prog-sketch12 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  (define coord3 (moving coord2   #:depth 1)) 
  (define coord4 (moving coord3   #:depth 1)) 
  (define coord5 (moving coord4   #:depth 1)) 
  (define coord6 (moving coord5   #:depth 1)) 
  (define coord7 (moving coord6   #:depth 1)) 
  (define coord8 (moving coord7   #:depth 1)) 
  (define coord9 (moving coord8   #:depth 1)) 
  (define coord10 (moving coord9   #:depth 1)) 
  (define coord11 (moving coord10   #:depth 1)) 
  (define coord12 (moving coord11   #:depth 1)) 
  coord12
)
(define before12 (current-inexact-milliseconds))

(define sol12
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 6) prog-sketch12 symbol-coord)))


(define after12 (current-inexact-milliseconds))
(define time12 (- after12 before12))
(set! outer-string (string-append outer-string "ras,12,"))
(set! outer-string (string-append outer-string (~s time12)))
(set! outer-string (string-append outer-string "\n"))
(print-forms sol12)


; ------------------ 
(printf "\n\nprog 14 ras way: \n")
(define (prog-sketch14 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  (define coord3 (moving coord2   #:depth 1)) 
  (define coord4 (moving coord3   #:depth 1)) 
  (define coord5 (moving coord4   #:depth 1)) 
  (define coord6 (moving coord5   #:depth 1)) 
  (define coord7 (moving coord6   #:depth 1)) 
  (define coord8 (moving coord7   #:depth 1)) 
  (define coord9 (moving coord8   #:depth 1)) 
  (define coord10 (moving coord9   #:depth 1)) 
  (define coord11 (moving coord10   #:depth 1)) 
  (define coord12 (moving coord11   #:depth 1)) 
  (define coord13 (moving coord12   #:depth 1)) 
  (define coord14 (moving coord13   #:depth 1)) 
  coord14
)
(define before14 (current-inexact-milliseconds))

(define sol14
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 7) prog-sketch14 symbol-coord)))


(define after14 (current-inexact-milliseconds))
(define time14 (- after14 before14))
(set! outer-string (string-append outer-string "ras,14,"))
(set! outer-string (string-append outer-string (~s time14)))
(set! outer-string (string-append outer-string "\n"))
(print-forms sol14)


; ------------------ 
(printf "\n\nprog 16 ras way: \n")
(define (prog-sketch16 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  (define coord3 (moving coord2   #:depth 1)) 
  (define coord4 (moving coord3   #:depth 1)) 
  (define coord5 (moving coord4   #:depth 1)) 
  (define coord6 (moving coord5   #:depth 1)) 
  (define coord7 (moving coord6   #:depth 1)) 
  (define coord8 (moving coord7   #:depth 1)) 
  (define coord9 (moving coord8   #:depth 1)) 
  (define coord10 (moving coord9   #:depth 1)) 
  (define coord11 (moving coord10   #:depth 1)) 
  (define coord12 (moving coord11   #:depth 1)) 
  (define coord13 (moving coord12   #:depth 1)) 
  (define coord14 (moving coord13   #:depth 1)) 
  (define coord15 (moving coord14   #:depth 1)) 
  (define coord16 (moving coord15   #:depth 1)) 
  coord16
)
(define before16 (current-inexact-milliseconds))

(define sol16
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 8) prog-sketch16 symbol-coord)))


(define after16 (current-inexact-milliseconds))
(define time16 (- after16 before16))
(set! outer-string (string-append outer-string "ras,16,"))
(set! outer-string (string-append outer-string (~s time16)))
(set! outer-string (string-append outer-string "\n"))
(print-forms sol16)


; ------------------ 
(printf "\n\nprog 18 ras way: \n")
(define (prog-sketch18 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  (define coord3 (moving coord2   #:depth 1)) 
  (define coord4 (moving coord3   #:depth 1)) 
  (define coord5 (moving coord4   #:depth 1)) 
  (define coord6 (moving coord5   #:depth 1)) 
  (define coord7 (moving coord6   #:depth 1)) 
  (define coord8 (moving coord7   #:depth 1)) 
  (define coord9 (moving coord8   #:depth 1)) 
  (define coord10 (moving coord9   #:depth 1)) 
  (define coord11 (moving coord10   #:depth 1)) 
  (define coord12 (moving coord11   #:depth 1)) 
  (define coord13 (moving coord12   #:depth 1)) 
  (define coord14 (moving coord13   #:depth 1)) 
  (define coord15 (moving coord14   #:depth 1)) 
  (define coord16 (moving coord15   #:depth 1)) 
  (define coord17 (moving coord16   #:depth 1)) 
  (define coord18 (moving coord17   #:depth 1)) 
  coord18
)
(define before18 (current-inexact-milliseconds))

(define sol18
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 9) prog-sketch18 symbol-coord)))


(define after18 (current-inexact-milliseconds))
(define time18 (- after18 before18))
(set! outer-string (string-append outer-string "ras,18,"))
(set! outer-string (string-append outer-string (~s time18)))
(set! outer-string (string-append outer-string "\n"))
(print-forms sol18)


; ------------------ 
(printf "\n\nprog 20 ras way: \n")
(define (prog-sketch20 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  (define coord3 (moving coord2   #:depth 1)) 
  (define coord4 (moving coord3   #:depth 1)) 
  (define coord5 (moving coord4   #:depth 1)) 
  (define coord6 (moving coord5   #:depth 1)) 
  (define coord7 (moving coord6   #:depth 1)) 
  (define coord8 (moving coord7   #:depth 1)) 
  (define coord9 (moving coord8   #:depth 1)) 
  (define coord10 (moving coord9   #:depth 1)) 
  (define coord11 (moving coord10   #:depth 1)) 
  (define coord12 (moving coord11   #:depth 1)) 
  (define coord13 (moving coord12   #:depth 1)) 
  (define coord14 (moving coord13   #:depth 1)) 
  (define coord15 (moving coord14   #:depth 1)) 
  (define coord16 (moving coord15   #:depth 1)) 
  (define coord17 (moving coord16   #:depth 1)) 
  (define coord18 (moving coord17   #:depth 1)) 
  (define coord19 (moving coord18   #:depth 1)) 
  (define coord20 (moving coord19   #:depth 1)) 
  coord20
)
(define before20 (current-inexact-milliseconds))

(define sol20
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 10) prog-sketch20 symbol-coord)))


(define after20 (current-inexact-milliseconds))
(define time20 (- after20 before20))
(set! outer-string (string-append outer-string "ras,20,"))
(set! outer-string (string-append outer-string (~s time20)))
(set! outer-string (string-append outer-string "\n"))
(print-forms sol20)
(write-file "output-files/timing-output/ras-timing.csv" outer-string)
