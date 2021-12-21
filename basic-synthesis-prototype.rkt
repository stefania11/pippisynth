#lang rosette
(require rosette/lib/synthax)     ; Require the sketching library.
(require racket/match)
; (output-smt #t)
; (require racket/pretty)
(error-print-width 10000000000)
(require 
  "moving-grammar.rkt" 
  "moving-checker.rkt"
  "iterative-deepening.rkt"
)


; EXAMPLE 1
; solution: (define (same-coord coord depth) coord)
(printf "EXAMPLE 1: \n----------\n")
(define (same-coord coord depth)
  (moving coord #:depth depth))

(iterative-deepening check-same same-coord)
(printf "\n\n")


; EXAMPLE 2
; solution: (define (one-coord coord depth) (moveLeft coord))
(printf "EXAMPLE 2: \n----------\n")
(define (one-coord coord depth)
  (moving coord #:depth depth))

(iterative-deepening check-one one-coord)
(printf "\n\n")

; EXAMPLE 3
; (define (go-diagonally coord depth) (moveUp (moveLeft coord)))
(printf "EXAMPLE 3: \n----------\n")
(define (go-diagonally-1 coord depth)
  (moving coord #:depth depth))

(iterative-deepening check-diag-1 go-diagonally-1)
(printf "\n\n")

; EXAMPLE 4
; solution: 
(printf "EXAMPLE 4: \n----------\n")
(define (go-diagonally-2 coord depth)
  (moving coord #:depth depth))

(iterative-deepening check-diag-2 go-diagonally-2)
(printf "\n\n")

; EXAMPLE 5
; solution:
(define (ex5-sketch coord depth)
  ; `depth` is unused 
  ; TODO: rewrite this sequence as a macro that repeats the body `depth` times.
  ;       Think why the solution in `ex5-sketch2, which uses a loop, as opposed
  ;       to a macro, doens't work as desired. 
  (define coord1 (moving coord   #:depth 1)) 
  (define coord2 (moving coord1  #:depth 1))
  (define coord3 (moving coord2  #:depth 1))
  (define coord4 (moving coord3  #:depth 1))
  (define coord5 (moving coord4  #:depth 1))
  (define coord6 (moving coord5  #:depth 1))
  coord6
  )

(define (ex5-sketch2 coord depth)
  (for ([i depth])
    (set! coord (moving coord   #:depth 1)))
  coord
)

(printf "EXAMPLE 5: \n----------\n")
(define (go-diagonally-3 coord depth)
  ;(moving coord #:depth depth)
  (ex5-sketch coord depth)
  )

(iterative-deepening check-diag-3 go-diagonally-3)
(printf "\n\n")