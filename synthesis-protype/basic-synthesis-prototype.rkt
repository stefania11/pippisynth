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
(printf "EXAMPLE 5: \n----------\n")
(define (go-diagonally-3 coord depth)
  (moving coord #:depth depth))

(iterative-deepening check-diag-3 go-diagonally-3)
(printf "\n\n")