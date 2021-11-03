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

(define (run-example checker coord ex-n)
  (printf "EXAMPLE ~s: \n----------\n" ex-n)
  (iterative-deepening checker coord)
  (printf "\n\n")
)


; EXAMPLE 1
; solution: (define (same-coord coord depth) coord)
(define (same-coord coord depth)
  (moving coord #:depth depth))

(run-example check-same same-coord 1)


; EXAMPLE 2
; solution: (define (one-coord coord depth) (moveLeft coord))
(define (one-coord coord depth)
  (moving coord #:depth depth))

(run-example check-one one-coord 2)


; EXAMPLE 3
; solution: (define (go-diagonally coord depth) (moveUp (moveLeft coord)))
(define (go-diagonally-1 coord depth)
  (moving coord #:depth depth))

(run-example check-diag-1 go-diagonally-1 3)


; EXAMPLE 4
; solution: (define (go-diagonally-2 coord depth)
;               (moveUp (moveUp (moveLeft (moveLeft coord)))))
(define (go-diagonally-2 coord depth)
  (moving coord #:depth depth))

(run-example check-diag-2 go-diagonally-2 4)


; EXAMPLE 5
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

(define (go-diagonally-3 coord depth)
  (ex5-sketch coord depth)
  )

(run-example check-diag-3 go-diagonally-3 5)


; Example w/o forall x y
(define (iterative-deepening-2 checker program)
    (define it-depth 0)
    (for ([i 100] #:break (= it-depth -1))
        (define sol-same
        (synthesize
            #:forall '()
            #:guarantee (checker it-depth program)))
        (if (sat? sol-same)
        (begin 
            (printf "solution found at it-depth ~s\n" it-depth)
            (printf "solution:\n")
            (print-forms sol-same)
            (set! it-depth -1))
        (begin
            (printf "no solution found at it-depth ~s\n" it-depth)
            (set! it-depth (+ it-depth 1))))))

(printf "ONE INPUT-OUTPUT EXAMPLE:\n-------------------------\n")
(iterative-deepening-2 check-diag-3-p go-diagonally-3)
(printf "\n\n")


; EXAMPLE 6
; solution:
(define (ex6-sketch coord depth)
  (define coord1 (moving coord   #:depth 1)) 
  (define coord2 (moving coord1  #:depth 1))
  (define coord3 (moving coord2  #:depth 1))
  (define coord4 (moving coord3  #:depth 1))
  (define coord5 (moving coord4  #:depth 1))
  (define coord6 (moving coord5  #:depth 1))
  (define coord7 (moving coord6  #:depth 1))
  (define coord8 (moving coord7  #:depth 1))
  coord8
  )

(define (go-diagonally-4 coord depth)
  (ex6-sketch coord depth)
  )

(run-example check-diag-4 go-diagonally-4 6)


; EXAMPLE 7
(define (blah coord depth)
  (ex6-sketch coord depth)
  )

(run-example check-same blah 7)


; (run-example check-same omg 10)
; (define (idk coord) 
;   (define new_c coord) 
;   new_c
; )

; (idk2 (list 1 2))

(define (sketch-3 coord)
  (define coord1 (moving coord   #:depth 1)) 
  (define coord2 (moving coord1  #:depth 1))
  (define coord3 (moving coord2  #:depth 1))
  coord3
  )

; (sketch-3 (list 1 2))

#|
TODO
    * look up what a macro is in racket
    * 

; this doesn't work because it's forcing the sketch
;   to repeat the same function from `moving`
;   instead of having a different one (potentially)
;   each time
(define (ex5-sketch2 coord depth)
  (for ([i depth])
    (set! coord (moving coord   #:depth 1)))
  coord
)
|#

(define (curr-ex-6 coord0 depth)
  (define coord1 (moving coord0 #:depth 1))
  (define coord2 (moving coord1 #:depth 1))
  (define coord3 (moving coord2 #:depth 1))
  (define coord4 (moving coord3 #:depth 1))
  (define coord5 (moving coord4 #:depth 1))
  coord5)


(define (curr-ex-456 coord0 depth)
  (define coord1 (moving coord0 #:depth 1))
  (define coord2 (moving coord1 #:depth 1))
  (define coord3 (moving coord2 #:depth 1))
  (define coord4 (moving coord3 #:depth 1))
  (define coord5 (moving coord4 #:depth 1))
  coord5)


(define (curr-ex-5 coord0 depth)
  coord0)


(define (curr-ex-6-2 coord0 depth)
  (define coord1 (moving coord0 #:depth 1))
  coord1)


(define (curr-ex-7 coord0 depth)
  (define coord1 (moving coord0 #:depth 1))
  (define coord2 (moving coord1 #:depth 1))
  coord2)


(define (curr-ex-8 coord0 depth)
  (define coord1 (moving coord0 #:depth 1))
  (define coord2 (moving coord1 #:depth 1))
  (define coord3 (moving coord2 #:depth 1))
  coord3)


(define (curr-ex-9 coord0 depth)
  (define coord1 (moving coord0 #:depth 1))
  (define coord2 (moving coord1 #:depth 1))
  (define coord3 (moving coord2 #:depth 1))
  (define coord4 (moving coord3 #:depth 1))
  coord4)
