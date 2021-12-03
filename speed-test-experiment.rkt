;TODO add description file top 


#lang rosette
; #lang rosette/safe

(require
  rosette/lib/synthax
  rosette/lib/destruct
)

(require 
  "grammar.rkt" 
  "coordinates.rkt" 
  "checker.rkt"

)

(require 2htdp/batch-io) ; used for time measurement 
(error-print-width 10000000000) ; used to print longer errror messages 



; Define a counting loop:
; defines a loop that iterates up to n times, calling body in each iteration, and
; breaking out when calling break-cond is true.  See below for sample usage. 
(define (for-loop n break-cond body)
  (cond
    [(break-cond) '()] ; break and return an empty list (TODO: is there a more reasonable value?)
    [(<= n 1) (body)]  ; perform the last iteration and return its value 
    [else (begin
            (body)
            (for-loop (sub1 n) break-cond body))]))




;TODO maybe rename checker functions and move them to checker file 
(define (checker-implies n impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (implies 
      (and
        (>= y 6)
        (>= x 6)
        (<= x 240)
        (<= y 240))
      (and 
        (= (+ x n) new-x) 
        (= (- y n) new-y)
        )
      ))
    ]))

(define (checker_new n impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert
      (and 
        (= (+ x n) new-x) 
        (= (- y n) new-y)
        )
      )
    ]))

;
; SKETCHES
;

(define (sk1 coord)
  (moving (moving coord #:depth 1) #:depth 1))

(define (sk1-1 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  coord2
)

(printf "sk1: \n\n")
(displayln (sk1 '(1 2)))
(printf "\n===========\nsk1-1: \n\n")
(displayln (sk1-1 '(1 2)))

(define (sk2 coord)
  (moving (moving (moving (moving coord #:depth 1) #:depth 1) #:depth 1) #:depth 1))

(define (sk2-1 coord0)
  (define coord1 (moving coord0   #:depth 1)) 
  (define coord2 (moving coord1   #:depth 1)) 
  (define coord3 (moving coord2   #:depth 1)) 
  (define coord4 (moving coord3   #:depth 1)) 
  coord4
)

(define (sk3 coord)
  (moving (moving (moving (moving (moving (moving (moving (moving coord #:depth 1) #:depth 1) #:depth 1) #:depth 1) #:depth 1) #:depth 1) #:depth 1) #:depth 1))


(define (sk3-1 coord0)
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

(define (sk4 coord)
  ; the loop updates the parameter coord, which we return at the end of sk3
  (for-loop 4
    (lambda () (is-at-bounds coord))
    (lambda () (set! coord (sk1-1 coord))))
  coord)

(define (sk5 coord)
  ; the loop updates the parameter coord, which we return at the end of sol2
  (for-loop 2
    (lambda () (is-at-bounds coord))
    (lambda () (set! coord (sk2-1 coord))))
  coord)

(define (sk6 coord)
  ; the loop updates the parameter coord, which we return at the end of sk3
  (for-loop 1
    (lambda () (is-at-bounds coord))
    (lambda () (set! coord (sk3-1 coord))))
  coord)


; Solver stuff
;

(define (doSynthesis sketch difference)

    (define symbol-coord (fresh-sym-coord))

    (define before (current-inexact-milliseconds))
    (define sol-same
      (synthesize
              #:forall symbol-coord
              #:guarantee ((curry checker-implies difference) sketch symbol-coord)))
                        
    (define after (current-inexact-milliseconds))
    (define time (- after before))
    (printf "\n\n=================\n")
    (if (sat? sol-same) 
            (begin 
                (printf "solution:\n")
                (print-forms sol-same))
            (begin
                (printf "no solution found\n")))
    (printf "\n***** time: ~s milliseconds\n" time)
)


; (doSynthesis sk1 1)
; (doSynthesis sk1-1 1)
; (doSynthesis sk2 2)
; (doSynthesis sk2-1 2)
; (doSynthesis sk3-1 4)
; ; (doSynthesis sk3 4)

; (doSynthesis sk4 4)
; (doSynthesis sk5 4)
; (doSynthesis sk6 4)




(define (sk3-1-trial coord0)
   (define coord1 (moveUp coord0))
   (define coord2 (moveUp coord1))
   (define coord3 (moveRight coord2))
   (define coord4 (moveRight coord3))
   (define coord5 (moveUp coord4))
   (define coord6 (moveRight coord5))
   (define coord7 (moveUp coord6))
   (define coord8 (moveRight coord7))
   coord8)

(define (sk6-trial coord)
  ; the loop updates the parameter coord, which we return at the end of sk3
  (for-loop 1
    (lambda () (is-at-bounds coord))
    (lambda () (set! coord (sk3-1-trial coord))))
  coord)

(displayln (sk6-trial '(6 6)))
