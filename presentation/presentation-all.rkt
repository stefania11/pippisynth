#lang rosette/safe

(require
  rosette/lib/synthax
  rosette/lib/destruct
  racket/match
)

(require 
  "moving-grammar.rkt" 
  "for-loop.rkt"
  "synthesis.rkt"
)


;
; move once
;
(define (move-left coord) 
    (moving coord #:depth 1))

(define (move-left-sol coord) 
    (moveLeft coord))

(define (check-left impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x 1) new-x))
     (assert (= y new-y))]))

(do-synthesis check-left move-left)

;
; move diagonally
;
(define (move-diagonally coord)
  (define coord1 (moving coord   #:depth 1))
  (define coord2 (moving coord1  #:depth 1))
  (define coord3 (moving coord2  #:depth 1))
  (define coord4 (moving coord3  #:depth 1))
  (define coord5 (moving coord4  #:depth 1))
  (define coord6 (moving coord5  #:depth 1))
   coord6)

(define (move-diagonally-sol coord)
   (define coord1 (moveLeft coord))
   (define coord2 (moveLeft coord1))
   (define coord3 (moveLeft coord2))
   (define coord4 (moveUp coord3))
   (define coord5 (moveUp coord4))
   (define coord6 (moveUp coord5))
   coord6)

(define (check-diagonal impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x 3) new-x))
     (assert (= (- y 3) new-y))]))

(do-synthesis check-diagonal move-diagonally)

;
; move diagonally loop
;
(define (move-diagonally-loop coord)

   (for-loop 3
    (lambda () #f)
    (lambda () (set! coord (moving coord #:depth 1))))
   
   (for-loop 3
    (lambda () #f)
    (lambda () (set! coord (moving coord #:depth 1))))

   coord)

(define (move-diagonally-loop-sol coord)

   (for-loop 3
    (lambda () #f)
    (lambda () (set! coord (moveLeft coord))))
   
   (for-loop 3
    (lambda () #f)
    (lambda () (set! coord (moveUp coord))))

   coord)

(define (check-diagonal-loop impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= (- x 3) new-x))
     (assert (= (- y 3) new-y))]))

(do-synthesis check-diagonal-loop move-diagonally-loop)

;
; meeting one quad
;
(define (meeting-one-quad coord-start coord-end)

   (define coord-curr coord-start)

   (for-loop 7
    (lambda () (bi-conditional coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))

   (for-loop 7
    (lambda () (bi-conditional coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))

   coord-curr)

(define (meeting-one-quad-sol coord-start coord-end)

   (define coord-curr coord-start)

   (for-loop 7
    (lambda () (same-x coord-curr coord-end))
    (lambda () (set! coord-curr (moveRight coord-curr))))

   (for-loop 7
    (lambda () (same-y coord-curr coord-end))
    (lambda () (set! coord-curr (moveDown coord-curr))))

   coord-curr)

(define (checker-one-quad impl coord-start coord-end)
  (destruct (append coord-start coord-end)
    [(list x1 y1 x2 y2)

      (define range 7)
      (define new-coord (impl coord-start coord-end))

      (assert (implies 

                ; the following ensures we have the correct
                ;    starting constraints to be able to synthesize
                ;    our goal
                (and
                    ; this is saying that (x2-range) <= x1 <= x2
                    (<= x1 x2)
                    (>= x1 (- x2 range))

                    ; this is saying that (y2-range) <= y1 <= y2
                    (<= y1 y2)
                    (>= y1 (- y2 range))
                )

                (coord-equals new-coord coord-end)
              )
      )
    ]
  )
)

(do-synthesis-bi checker-one-quad meeting-one-quad)

;
; meeting 4 quads
;
(define (meeting-four-quads coord-start coord-end)

  (define coord-curr coord-start)

  (for-loop 14

    (lambda () (coord-equals coord-curr coord-end))
    (lambda () (cond

          [(bi-conditional coord-curr coord-end #:depth 1)
            (set! coord-curr (moving coord-curr #:depth 1))]

          [(bi-conditional coord-curr coord-end #:depth 1)
            (set! coord-curr (moving coord-curr #:depth 1))]

          [(bi-conditional coord-curr coord-end #:depth 1)
            (set! coord-curr (moving coord-curr #:depth 1))]

          [(bi-conditional coord-curr coord-end #:depth 1)
            (set! coord-curr (moving coord-curr #:depth 1))
          ])))

  coord-curr)


(define (meeting-four-quads-sol coord-start coord-end)

  (define coord-curr coord-start)

  (for-loop 14

    (lambda () (coord-equals coord-curr coord-end))
    (lambda () (cond

          [(is-below coord-curr coord-end)
            (set! coord-curr (moveUp coord-curr))]

          [(is-to-left coord-curr coord-end)
            (set! coord-curr (moveRight coord-curr))]

          [(is-above coord-curr coord-end)
            (set! coord-curr (moveDown coord-curr))]

          [(is-to-right coord-curr coord-end)
            (set! coord-curr (moveLeft coord-curr))
          ])))

  coord-curr)

(define (checker-four-quads impl coord-start coord-end)
  (destruct (append coord-start coord-end)
    [(list x1 y1 x2 y2)

      (define range 7)
      (define new-coord (impl coord-start coord-end))

      (assert (implies 

                ; the following ensures we have the correct
                ;    starting constraints to be able to synthesize
                ;    our goal
                (and
                    ; this is saying that (x2-range) <= x1 <= (x2+range)
                    (<= x1 (+ x2 range))
                    (>= x1 (- x2 range))

                    ; this is saying that (y2-range) <= y1 <= (y2+range)
                    (<= y1 (+ y2 range))
                    (>= y1 (- y2 range))
                )

                (coord-equals new-coord coord-end)
              )
      )
    ]
  )
)

(do-synthesis-bi checker-four-quads meeting-four-quads)
