#lang rosette
(require rosette/lib/synthax)     ; Require the sketching library.
(require racket/match)
(output-smt #t)
(error-print-width 10000000000)
(require dyoo-while-loop)
(require 
  "../../moving-grammar.rkt" 
)
(require racket/sandbox)

(define (checker n depth impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord depth))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x n) new-x))
     (assert (= (- y n) new-y))]))

(define-symbolic x y integer?) 
(define symbol-coord (list x y))

(define (run-checker checker program prog-depth)
  (with-deep-time-limit 50
    (define sol
      (synthesize
                #:forall symbol-coord
                #:guarantee (checker prog-depth program symbol-coord)))
    (print-forms sol)
  )
)



; ------------------ 
(printf "\n\nprog 2 darya way: \n")
(define (sketch2 coord sketch-depth)
	(moving coord #:depth sketch-depth))

(run-checker (curry checker 1) sketch2 2)


; ------------------ 
(printf "\n\nprog 4 darya way: \n")
(define (sketch4 coord sketch-depth)
	(moving coord #:depth sketch-depth))

(run-checker (curry checker 2) sketch4 4)


; ------------------ 
(printf "\n\nprog 6 darya way: \n")
(define (sketch6 coord sketch-depth)
	(moving coord #:depth sketch-depth))

(run-checker (curry checker 3) sketch6 6)
