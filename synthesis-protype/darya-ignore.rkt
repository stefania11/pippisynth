; #lang rosette
#lang rosette/safe

(require
  rosette/lib/synthax
  rosette/lib/destruct
)

(require 
  "moving-grammar.rkt" 
)

(require 2htdp/batch-io)
; (error-print-width 10000000000)



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


;
; Coordinate stuff
;

(define (fresh-sym-coord) 
  (define-symbolic* x y integer?)   ; note the '*' in define-symbolic*
  (list x y))

(define (coord-equals coord coord2)
  (destruct (append coord coord2)
    [(list x y x2 y2)
     (and (= x x2)
          (= y y2))]))

(define (coord-x coord)
  (list-ref coord 0))

(define (coord-y coord)
  (list-ref coord 1))

(define (coord-add coord coord2)
  (destruct (append coord coord2)
    [(list x y x2 y2)
     (list (+ x x2)
           (+ y y2))]))


(define (is-to-right coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
        (> x1 x2)
    ]
  )
)
(define (is-to-left coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (< x1 x2)
    ]
  )
)
(define (is-up coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (< y1 y2)
    ]
  )
)
(define (is-down coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (> y1 y2)
    ]
  )
)


(define (same-x coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (= x1 x2)
    ]
  )
)

(define (same-y coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (= y1 y2)
    ]
  )
)




(define-grammar (conditional coord)
  [expr
   (choose #f
           #t
           (is-at-bounds coord)
           )])

(define-grammar (bi-conditional coord1 coord2)
  [expr
   (choose #f
           #t
          (same-x coord1 coord2)
          (same-y coord1 coord2)
          ;  (is-to-right coord1 coord2)
          ;  (is-to-left coord1 coord2)
          ;  (is-up coord1 coord2)
          ;  (is-down coord1 coord2)
           )])

;
; Various board position predicates 
;

(define top-row 0)  ; y coordinate of the top row
(define bottom-row 250)
(define left-col 0)
(define right-col 250)

; difference here is that we're checking if it is AT the bounds
;  instead of already outside the bounds
(define (is-at-bounds coord)
  (destruct coord
    [(list x y) (or 
        (= y top-row)
        (= y bottom-row)
        (= x left-col)
        (= x right-col)
    )]))

(define (checker-implies n impl coord)
  (destruct coord
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

(define (checker n impl coord)
  (destruct coord
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

; (printf "sk1: \n\n")
; (displayln (sk1 '(1 2)))
; (printf "\n===========\nsk1-1: \n\n")
; (displayln (sk1-1 '(1 2)))

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

    ; (define before (current-inexact-milliseconds))
    (define sol-same
      (synthesize
              #:forall symbol-coord
              #:guarantee ((curry checker-implies difference) sketch symbol-coord)))
                        
    ; (define after (current-inexact-milliseconds))
    ; (define time (- after before))
    (printf "\n\n=================\n")
    (if (sat? sol-same) 
            (begin 
                (printf "solution:\n")
                (print-forms sol-same))
            (begin
                (printf "no solution found\n")))
    ; (printf "\n***** time: ~s milliseconds\n" time)
)


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






(define (checker-same-bi impl coord-start coord-end)
  (destruct (append coord-start coord-end)
    [(list x1 y1 x2 y2)
     (define new-coord (impl coord-start coord-end))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (implies 
      (and
        (<= x1 x2)
        (>= x1 (- x2 4))
        (<= y1 y2)
        (>= y1 (- y2 4))

      )
      (and 
        (= x2 new-x) 
        (= y2 new-y)
        )
      ))
    ]
  )
)
; (displayln (sk6-trial '(6 6)))

(define (sk-loop coord-start coord-end)
  (define coord-curr coord-start)
  (for-loop 7
    (lambda () (bi-conditional coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  (for-loop 7
    (lambda () (bi-conditional coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  coord-curr
)

(define (trial-checker impl)
  (destruct (list 5 5 8 9)
    [(list x1 y1 x2 y2)
     (define new-coord (impl (list x1 y1) (list x2 y2)))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert 
      (and 
        (= x2 new-x) 
        (= y2 new-y)
        )
      )
    ]
  )
)

;  TODO this isn't working - make sure implication things are correct !!! I think that's where it's wrong 


(define (doSynthesis-bi sketch)

    (define symbol-coord-start (fresh-sym-coord))
    (define symbol-coord-end   (fresh-sym-coord))

    ; (define before (current-inexact-milliseconds))
    (define sol-same
      (synthesize
              #:forall (list symbol-coord-start symbol-coord-end)
              #:guarantee (checker-same-bi sketch symbol-coord-start symbol-coord-end)))
                        
    ; (define after (current-inexact-milliseconds))
    ; (define time (- after before))
    (printf "\n\n=================\n")
    (if (sat? sol-same) 
            (begin 
                (printf "solution:\n")
                (print-forms sol-same))
            (begin
                (printf "no solution found\n")))
    ; (printf "\n***** time: ~s milliseconds\n" time)
)

(doSynthesis-bi sk-loop)

(define (doSynthesis-trial sketch)

    ; (define symbol-coord-start (fresh-sym-coord))
    ; (define symbol-coord-end   (fresh-sym-coord))

    ; (define before (current-inexact-milliseconds))
    ; (trial-checker sketch)
    (define sol-same
      (synthesize
              #:forall '()
              #:guarantee (trial-checker sketch)))
                        
    ; (define after (current-inexact-milliseconds))
    ; (define time (- after before))
    (printf "\n\n=================\n")
    (if (sat? sol-same) 
            (begin 
                (printf "solution:\n")
                (print-forms sol-same))
            (begin
                (printf "no solution found\n")))
    ; (printf "\n***** time: ~s milliseconds\n" time)
)

; (doSynthesis-trial sk-loop)

(define (sk-loop-sol coord-start coord-end)
  (for-loop 4
    (lambda () (same-y coord-start coord-end))
    (lambda () (set! coord-start (moveDown coord-start))))
  (for-loop 4
    (lambda () (same-x coord-start coord-end))
    (lambda () (set! coord-start (moveRight coord-start))))
  coord-start
)

; (sk-loop-sol (list 5 5) (list 8 9))
; (trial-checker sk-loop-sol)