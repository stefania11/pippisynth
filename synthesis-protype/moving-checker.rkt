#lang rosette
(require rosette/lib/synthax)     ; Require the sketching library.
(require racket/match)


(provide 
  check-same
  check-one
  checker-test
  check-diag-1
  check-diag-2
  check-diag-3
  check-diag-3-p
  check-diag-4
)


; CHECKER
(define (check-same depth impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord depth))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= x new-x))
     (assert (= y new-y))]))

(define (check-one depth impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord depth))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x 1) new-x))
     (assert (= y new-y))]))

(define (checker-test depth impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord depth))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= x new-x))
     (assert (= y new-y))])) 

(define (check-diag-n n depth impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord depth))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x n) new-x))
     (assert (= (- y n) new-y))]
    [_ "error wrong format for coordinate"]))

(define (check-diag-1 depth impl coord)
    (check-diag-n 1 depth impl coord))

(define (check-diag-2 depth impl coord)
    (check-diag-n 2 depth impl coord))

(define (check-diag-3 depth impl coord)
    (check-diag-n 3 depth impl coord)
    ; (check-diag-3-p 3 depth impl (list 8 8))
    )

(define (check-diag-4 depth impl coord)
    (check-diag-n 4 depth impl coord))

; for specific coordinate
(define (check-diag-3-p depth impl)
    (define coord (list 8 8))
    (define new-coord (impl coord depth))
    (define new-x (list-ref new-coord 0))
    (define new-y (list-ref new-coord 1))
    (assert (= 5 new-x))
    (assert (= 5 new-y)))

(define-symbolic x y integer?) 
(define symbol-coord (list x y))
