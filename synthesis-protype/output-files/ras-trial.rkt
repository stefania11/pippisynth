#lang rosette
(require rosette/lib/synthax)     ; Require the sketching library.
(require racket/match)
(require 2htdp/batch-io)
(error-print-width 10000000000)
(require 
  "../moving-grammar.rkt"
)

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
(write-file "output-files/ras.csv" outer-string)
