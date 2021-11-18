#lang rosette
(require rosette/lib/synthax)     ; Require the sketching library.
(require racket/match)
(require 2htdp/batch-io)
(error-print-width 10000000000)
(require 
  "../../moving-grammar.rkt"
)
(require racket/sandbox)

(output-smt #t)
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



; ------------------ 
(printf "\n\nprog 2 ras way: \n")
(define (prog-sketch2 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  coord2
)

(define sol2
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 1) prog-sketch2 symbol-coord)))


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

(define sol4
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 2) prog-sketch4 symbol-coord)))


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

(define sol6
  (synthesize
      #:forall symbol-coord
      #:guarantee ((curry checker 3) prog-sketch6 symbol-coord)))


(print-forms sol6)
