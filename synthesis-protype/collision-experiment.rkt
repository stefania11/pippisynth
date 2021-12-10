#lang rosette
; #lang rosette/safe

(require
  rosette/lib/synthax
  rosette/lib/destruct
)

(require 
  "moving-grammar.rkt" 
)

; (require 2htdp/batch-io)
(require racket/sandbox)


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

(define (same-x coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (= x1 x2)]))

(define (same-y coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (= y1 y2)]))

; (coord2) ... (coord1)
(define (is-to-right coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
        (> x1 x2)
    ]
  )
)

; (coord1) ... (coord2)
(define (is-to-left coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (< x1 x2)
    ]
  )
)

; (coord2) 
; ...
; (coord1)
(define (is-below coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (> y1 y2)
    ]
  )
)

; (coord1) 
; ...
; (coord2)
(define (is-above coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (< y1 y2)
    ]
  )
)

; (coord2) (coord1)
(define (is-right-neighbor-of coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (&& (= x1 (+ x2 1))
          (= y1 y2))
    ]
  )
)

; (coord1) (coord2)
(define (is-left-neighbor-of coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (&& (= (+ x1 1) x2)
          (= y1 y2))
    ]
  )
)

; (coord1)
; (coord2)
(define (is-above-neighbor-of coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (&& (= (+ y1 1) y2)
          (= x1 x2))
    ]
  )
)

; (coord2)
; (coord1)
(define (is-below-neighbor-of coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x1 y1 x2 y2)
      (&& (= y1 (+ y2 1))
          (= x1 x2))
    ]
  )
)

;
; Conditional grammar (new!!)
;

; TODO rename to have something to do with 
;   relative position (view Stef's refactoring)
(define-grammar (bi-conditional coord1 coord2)
    [expr
        (choose 
                ; (same-x coord1 coord2)
                ; (same-y coord1 coord2)
                (is-to-right coord1 coord2)
                (is-to-left coord1 coord2)
                (is-below coord1 coord2)
                (is-above coord1 coord2)
        )
    ]
)

(define-grammar (neigbor-grammar coord1 coord2)
  [expr
        (choose 
                (is-right-neighbor-of coord1 coord2)
                (is-below-neighbor-of coord1 coord2)
                ; (not (is-right-neighbor-of coord1 coord2))
                ; (not (is-below-neighbor-of coord1 coord2))
                (is-left-neighbor-of coord1 coord2)
                (is-above-neighbor-of coord1 coord2)
        )
    ]
)

(define-grammar (tri-conditional coord-start coord-end coord-collision)
    [expr
      (choose (&& (bi-conditional coord-start coord-end) 
                  (neigbor-grammar coord-start coord-collision))
              (&& (bi-conditional coord-start coord-end) 
                  (not (neigbor-grammar coord-start coord-collision)))
      )
    ]
)

; (define-grammar (bi-conditional coord1 coord2)
;     [expr
;         (choose (same-x coord1 coord2)
;                 (same-y coord1 coord2)
;         )
;     ]
; )

;
; Various board position predicates 
;

(define top-row 0)
(define bottom-row 250)
(define left-col 0)
(define right-col 250)

; (new!!) different than `is-out-of-bounds`
;   difference here is that we're checking if it is AT the bounds
;   instead of already outside the bounds
;   I (darya) find this to be a better checker 
;   (we want to stop AT bounds, not once we're already outside them)
;   THIS ISN'T USED BUT I WANTED TO INCLUDE FOR FURTHER EXPLORATION
(define (is-at-bounds coord)
  (destruct coord
    [(list x y) (or 
        (= y top-row)
        (= y bottom-row)
        (= x left-col)
        (= x right-col)
    )]))

; TODO comment
(define (is-in-bounds coord)
  (destruct coord
    [(list x y) (and 
        (>= y top-row)
        (< y bottom-row)
        (>= x left-col)
        (< x right-col)
    )]))
    
;
; SKETCHES
;

(define (sk-meet coord-start coord-end)
  (define coord-curr coord-start)
  (for-loop 7
    (lambda () (bi-conditional coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  (for-loop 7
    (lambda () (bi-conditional coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  coord-curr
)


(define (sk-meet-4-quads range coord-start coord-end)
  (define coord-curr coord-start)
  (for-loop (* 2 range)
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
  coord-curr
)

(define (sketch-collision-4-quads range coord-start coord-end coord-collision)
  (define coord-curr coord-start)
  (for-loop (* 2 range)
    (lambda () (coord-equals coord-curr coord-end))
    (lambda () (begin 
                (cond
                    [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                        (begin 
                          (set! coord-curr (moveLeft coord-curr))
                        )]

                    [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                        (begin 
                          (set! coord-curr (moveUp coord-curr))
                        )]

                    [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                        (begin 
                          (set! coord-curr (moveRight coord-curr))
                        )]

                    [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                        (begin 
                          (set! coord-curr (moveDown coord-curr))
                        )]

                    ; stuck trying to go left
                    [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                        (begin 
                            (set! coord-curr (moveUp coord-curr))
                            (set! coord-curr (moveLeft coord-curr))
                        )]

                    ; stuck trying to go up
                    [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                        (begin 
                            (set! coord-curr (moveRight coord-curr))
                            (set! coord-curr (moveUp coord-curr))
                        )]
                    
                    ; stuck trying to go right
                    [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                        (begin 
                            (set! coord-curr (moveUp coord-curr))
                            (set! coord-curr (moveRight coord-curr))
                        )]

                    ; stuck trying to go down
                    [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                        (begin 
                            (set! coord-curr (moveRight coord-curr))
                            (set! coord-curr (moveDown coord-curr))
                        )]
                  ) 
                  (assert (not (coord-equals coord-curr coord-collision)))
                )
    )
  )
  coord-curr
)

; (define (sketch-collision range coord-start coord-end coord-collision)
;   (define coord-curr coord-start)
;   (for-loop (* 2 range)
;     (lambda () (coord-equals coord-curr coord-end))
;     (lambda () ;(begin 
;       (cond
;         [(&& (is-below coord-curr coord-end)) ;(not (is-below-neighbor-of coord-curr coord-collision)))
;             (set! coord-curr (moving coord-curr #:depth 1))]
;         [(&& (is-above coord-curr coord-end)) ;(not (is-above-neighbor-of coord-curr coord-collision)))
;             (set! coord-curr (moving coord-curr #:depth 1))]
;         [(&& (is-to-right coord-curr coord-end)) ;(not (is-right-neighbor-of coord-curr coord-collision)))
;             (set! coord-curr (moving coord-curr #:depth 1))]
;         [(&& (is-to-left coord-curr coord-end)) ;(not (is-left-neighbor-of coord-curr coord-collision)))
;             (set! coord-curr (moving coord-curr #:depth 1))
;         ])
;       ; (assert (not (coord-equals coord-curr coord-collision)))
;       ;)
;     )
;   )
;   coord-curr
; )

; (define (sketch-collision-final range coord-start coord-end coord-collision)
;   (define coord-curr coord-start)
;   (for-loop (* 2 range)
;     (lambda () (coord-equals coord-curr coord-end))
;     (lambda () (begin 
;       (cond
;         [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
;             (set! coord-curr (moving coord-curr #:depth 1))]
;         [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
;             (set! coord-curr (moving coord-curr #:depth 1))]
;         [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
;             (set! coord-curr (moving coord-curr #:depth 1))]
;         [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
;             (set! coord-curr (moving coord-curr #:depth 1))
;         ])
;       (assert (not (coord-equals coord-curr coord-collision))))))
;   coord-curr
; )

;
; CHECKERS
;

(define (checker-same-bi impl coord-start coord-end)
  (destruct (append coord-start coord-end)
    [(list x1 y1 x2 y2)

    ; TODO see if moving this later makes any difference
     (define new-coord (impl coord-start coord-end))

     (assert (implies 
                (and
                    ; this is saying that (x2-7) <= x1 <= x2
                    (<= x1 x2)
                    (>= x1 (- x2 7))

                    ; this is saying that (y2-7) <= y1 <= y2
                    (<= y1 y2)
                    (>= y1 (- y2 7))
                )
                (coord-equals new-coord coord-end)
             ))
    ]
  )
)

(define (checker-4-quads range impl coord-start coord-end)
  (destruct (append coord-start coord-end)
    [(list x1 y1 x2 y2)

     (define new-coord (impl coord-start coord-end))

     (assert (implies 
                (and
                    ; TODO this gives enough to be able to achieve goal
                    ; this is saying that (x2-7) <= x1 <= (x2+7)
                    (<= x1 (+ x2 range))
                    (>= x1 (- x2 range))

                    ; this is saying that (y2-7) <= y1 <= (y2+7)
                    (<= y1 (+ y2 range))
                    (>= y1 (- y2 range))
                )
                (coord-equals new-coord coord-end)
             ))
    ]
  )
)

(define (checker-collision-4-quads range impl coord-start coord-end coord-collision)
  (destruct (append coord-start coord-end)
    [(list x1 y1 x2 y2)

        ; (define new-coord (impl range coord-start coord-end coord-collision))
        ; ; this is saying that (x2 + 2) <= x1 <= (x2+range)
        ; (assume (> x1 (+ x2 2)))
        ; (assume (<= x1 (+ x2 range)))

        ; ; this is saying that (y2 + 2) <= y1 <= (y2+range)
        ; (assume (> y1 (+ y2 2)))
        ; (assume (<= y1 (+ y2 range)))

        ; this is saying that (x2-range) <= x1 <= (x2+range)
        (assume (<= x1 (+ x2 range)))
        (assume (>= x1 (- x2 range)))

        ; this is saying that (y2-range) <= y1 <= (y2+range)
        (assume (<= y1 (+ y2 range)))
        (assume (>= y1 (- y2 range)))

        ; collision must be different than start and end
        (assume (not (coord-equals coord-start coord-collision)))
        (assume (not (coord-equals coord-end coord-collision)))

        ; (printf "oofers here\n")
        (define new-coord (impl range coord-start coord-end coord-collision))

        (assert (coord-equals new-coord coord-end))
    ;  (assert (implies 
    ;             (and
    ;                 ; TODO this gives enough to be able to achieve goal
    ;                 ; (is-in-bounds coord-start)
    ;                 ; (is-in-bounds coord-end)
    ;                 ; (is-in-bounds coord-collision)
    ;                 (and 
    ;                   (not (same-x coord-start coord-end))
    ;                   (not (same-y coord-start coord-end)))
    ;                 ; this is saying that (x2-7) <= x1 <= (x2+7)
    ;                 (<= x1 (+ x2 range))
    ;                 (>= x1 (- x2 range))

    ;                 ; this is saying that (y2-7) <= y1 <= (y2+7)
    ;                 (<= y1 (+ y2 range))
    ;                 (>= y1 (- y2 range))

    ;                 ; TODO coord-collision needs to be in board
                    
    ;                 ;collision  must be different than start and end
    ;                 (not (coord-equals coord-start coord-collision))
    ;                 (not (coord-equals coord-end coord-collision))
    ;             )
    ;             (coord-equals new-coord coord-end)
    ;          ))
    ]
  )
)





; TODO check why it's slow 
;     * maybe remove a conditional statement and see if this makes it slower 

(define outer-string "")
(set! outer-string (string-append outer-string "size,time\n"))


;
; SOLVERS
;

; (define (do-synthesis-bi checker sketch)

;     (define symbol-coord-start (fresh-sym-coord))
;     (define symbol-coord-end   (fresh-sym-coord))

;     (define before (current-inexact-milliseconds))
;     (define sol-same
;       (synthesize
;               #:forall (list symbol-coord-start symbol-coord-end)
;               #:guarantee (checker sketch symbol-coord-start symbol-coord-end)))
    
;     (define after (current-inexact-milliseconds))
;     (define time (- after before))

;     ; (printf "\n\n=================\n")
;     (if (sat? sol-same) 
;             (begin 
;                 (printf "solution:\n")
;                 (print-forms sol-same))
;             (begin
;                 (printf "no solution found\n")))
    
;     ; (printf "\n***** time: ~s milliseconds\n" time)
;     time
; )   

; (define (do-synthesis-tri checker sketch)

;     (define symbol-coord-start (fresh-sym-coord))
;     (define symbol-coord-end   (fresh-sym-coord))
;     (define symbol-coord-collision   (fresh-sym-coord))

;     ; (define before (current-inexact-milliseconds))
;     (define sol-same
;       (synthesize
;               #:forall (list symbol-coord-start symbol-coord-end symbol-coord-collision)
;               #:guarantee (checker 4 sketch symbol-coord-start symbol-coord-end symbol-coord-collision)))
    
;     ; (define after (current-inexact-milliseconds))
;     ; (define time (- after before))

;     ; (printf "\n\n=================\n")
;     (if (sat? sol-same) 
;             (begin 
;                 (printf "solution:\n")
;                 (print-forms sol-same))
;             (begin
;                 (printf "no solution found\n")))
    
;     ; (printf "\n***** time: ~s milliseconds\n" time)
;     ; time
; ) 

; (do-synthesis-tri checker-collision sketch-collision)

; TODO instead of going up if stuck, go left and up and keep going 
; try with just one quad example
; dont worry about borders yet 

(define (sketch-collision-4-quads-my-sol range coord-start coord-end coord-collision)
  (define coord-curr coord-start)
  (for-loop (* 2 range)
    (lambda () (coord-equals coord-curr coord-end))
    (lambda () (begin 
                (cond
                    [(&& (is-to-right coord-curr coord-end) (not (is-right-neighbor-of coord-curr coord-collision)))
                        (begin 
                          (set! coord-curr (moveLeft coord-curr))
                        )]

                    [(&& (is-below coord-curr coord-end) (not (is-below-neighbor-of coord-curr coord-collision)))
                        (begin 
                          (set! coord-curr (moveUp coord-curr))
                        )]

                    [(&& (is-above coord-curr coord-end) (not (is-above-neighbor-of coord-curr coord-collision)))
                        (begin 
                          (set! coord-curr (moveDown coord-curr))
                        )]

                    [(&& (is-to-left coord-curr coord-end) (not (is-left-neighbor-of coord-curr coord-collision)))
                        (begin 
                          (set! coord-curr (moveRight coord-curr))
                        )]

                    ; stuck trying to go left
                    [(&& (is-below coord-curr coord-end) (not (is-below-neighbor-of coord-curr coord-collision)))
                        (begin 
                            (set! coord-curr (moveUp coord-curr))
                            (set! coord-curr (moveLeft coord-curr))
                        )]

                    ; stuck trying to go up
                    [(&& (is-below coord-curr coord-end) (not (is-right-neighbor-of coord-curr coord-collision)))
                        (begin 
                            (set! coord-curr (moveRight coord-curr))
                            (set! coord-curr (moveUp coord-curr))
                        )]
                    
                    ; stuck trying to go right
                    [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                        (begin 
                            (set! coord-curr (moveUp coord-curr))
                            (set! coord-curr (moveRight coord-curr))
                        )]

                    ; stuck trying to go down
                    [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                        (begin 
                            (set! coord-curr (moveRight coord-curr))
                            (set! coord-curr (moveDown coord-curr))
                        )]
                  ) 
                  (assert (not (coord-equals coord-curr coord-collision)))
                )
    )
  )
  coord-curr
)


; (define (sketch-collision-sol range coord-start coord-end coord-collision)
;   (define coord-curr coord-start)
;   (for-loop (* 2 range)
;     (lambda () (coord-equals coord-curr coord-end))
;     (lambda () (begin 
;       (cond
;         [(&& (is-below coord-curr coord-end) (not (is-below-neighbor-of coord-curr coord-collision)))
;             (begin 
;               (set! coord-curr (moveUp coord-curr))
;               (printf "moveUp - coord-curr: ~s\n" coord-curr))]
        
;         [(&& (is-above coord-curr coord-end) (not (is-above-neighbor-of coord-curr coord-collision)))
;             (begin 
;               (set! coord-curr (moveDown coord-curr))
;               (printf "moveDown - coord-curr: ~s\n" coord-curr))]
        
;         [(&& (is-to-right coord-curr coord-end) (not (is-right-neighbor-of coord-curr coord-collision)))
;             (begin 
;               (set! coord-curr (moveLeft coord-curr))
;               (printf "moveLeft - coord-curr: ~s\n" coord-curr))]
        
;         [(&& (is-to-left coord-curr coord-end) (not (is-left-neighbor-of coord-curr coord-collision)))
;             (begin 
;               (set! coord-curr (moveRight coord-curr))
;               (printf "moveRight - coord-curr: ~s\n" coord-curr))
;         ])
;       (assert (not (coord-equals coord-curr coord-collision)))
;               )
;     )
;   )
;   coord-curr
; )

(define (sketch-collision-one-quad range coord-start coord-end coord-collision)
  (define coord-curr coord-start)
  (for-loop (+ (* 2 range) 2)
    (lambda () (coord-equals coord-curr coord-end))
    (lambda () (begin 
                  (cond
                    
                    ; [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                    [(&& (bi-conditional coord-start coord-end) (not (neigbor-grammar coord-start coord-collision)))
                        (begin 
                          (set! coord-curr (moveLeft coord-curr))
                        )]

                    ; [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                    [(&& (bi-conditional coord-start coord-end) (not (neigbor-grammar coord-start coord-collision)))
                        (begin 
                          (set! coord-curr (moveUp coord-curr))
                        )]

                    ; [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                    [(&& (bi-conditional coord-start coord-end) (neigbor-grammar coord-start coord-collision))
                        (begin 
                            (set! coord-curr (moveUp coord-curr))
                            (set! coord-curr (moveLeft coord-curr))
                        )]

                    ; [(tri-conditional coord-curr coord-end coord-collision #:depth 1)
                    [(&& (bi-conditional coord-start coord-end) (neigbor-grammar coord-start coord-collision))
                        (begin 
                            (set! coord-curr (moveRight coord-curr))
                            (set! coord-curr (moveUp coord-curr))
                        )]
                  ) 
                  (assert (not (coord-equals coord-curr coord-collision)))
               )
    )
  )
  coord-curr
)


(define (checker-collision-one-quad range impl coord-start coord-end coord-collision)
  (destruct (append coord-start coord-end)
    [(list x1 y1 x2 y2)

      ; this is saying that (x2 + 2) <= x1 <= (x2+range)
      (assume (> x1 (+ x2 2)))
      (assume (<= x1 (+ x2 range)))

      ; this is saying that (y2 + 2) <= y1 <= (y2+range)
      (assume (> y1 (+ y2 2)))
      (assume (<= y1 (+ y2 range)))
                
      ; collision must be different than start and end
      (assume (not (coord-equals coord-start coord-collision)))
      (assume (not (coord-equals coord-end coord-collision)))
              
      (define new-coord (impl range coord-start coord-end coord-collision))
      
      (assert (coord-equals new-coord coord-end))
    ]
  )
)

; (sketch-collision-sol 4 (list 5 5) (list 7 7) (list 1000 10000))

; (checker-collision 4 sketch-collision-sol (list 5 5) (list 7 7) (list 1000 10000))

(define (verify-tri checker sketch)

    (define symbol-coord-start (fresh-sym-coord))
    (define symbol-coord-end   (fresh-sym-coord))
    (define symbol-coord-collision   (fresh-sym-coord))

    (define sol (verify (checker sketch symbol-coord-start symbol-coord-end symbol-coord-collision)))
    ; (define sol (verify (checker-collision 4 sketch-collision-sol symbol-coord-start symbol-coord-end symbol-coord-collision)))

    (if (sat? sol) 
            (begin 
                (printf "didn't work on following inputs:\n")
                (displayln sol))
            (begin
                (printf "verified \n")))
) 
; (verify-tri checker-collision-one-quad sketch-collision-one-quad)
; (verify-tri checker-collision-4-quads sketch-collision-4-quads-my-sol)


(define (do-synthesis-tri-collision checker sketch)

    ; (define coord-start (list 7 7))
    ; (define coord-end   (list 5 4))
    ; (define coord-collision   (list 5 6))
    (define symbol-coord-start (fresh-sym-coord))
    (define symbol-coord-end   (fresh-sym-coord))
    (define symbol-coord-collision   (fresh-sym-coord))

    ; (define before (current-inexact-milliseconds))
    (define sol-same
      (synthesize
              #:forall (list symbol-coord-start symbol-coord-end symbol-coord-collision)
              #:guarantee (checker 4 sketch symbol-coord-start symbol-coord-end symbol-coord-collision)))
    
    ; (define after (current-inexact-milliseconds))
    ; (define time (- after before))

    ; (printf "\n\n=================\n")
    (if (sat? sol-same) 
            (begin 
                (printf "solution:\n")
                (print-forms sol-same))
            (begin
                (printf "no solution found\n")))
    
    ; (printf "\n***** time: ~s milliseconds\n" time)
    ; time
) 


(do-synthesis-tri-collision checker-collision-one-quad sketch-collision-one-quad)
; (do-synthesis-tri-collision checker-collision-4-quads sketch-collision-4-quads)


(define coord-start (list 7 7))
(define coord-end   (list 5 4))
(define coord-collision   (list 5 6))

; (define (sketch-collision-one-quad-sol range coord-start coord-end coord-collision)
;   (define coord-curr coord-start)
;   (for-loop (+ (* 2 range) 2)
;     (lambda () (coord-equals coord-curr coord-end))
;     (lambda () (begin 
;                   (cond
                    
;                     [(&& (is-to-right coord-curr coord-end)
;                          (not (is-right-neighbor-of coord-curr coord-collision)))
;                         (begin 
;                           (set! coord-curr (moveLeft coord-curr))
;                           ; (printf "moveLeft - ~s, coll: ~s\n" coord-curr coord-collision)
;                         )]
                        
;                     [(&& (is-below coord-curr coord-end)
;                         (not (is-below-neighbor-of coord-curr coord-collision)))
;                         (begin 
;                           (set! coord-curr (moveUp coord-curr))
;                           ; (printf "moveUp - ~s, coll: ~s\n" coord-curr coord-collision)
;                         )]

;                     [(&& (is-to-right coord-curr coord-end)
;                          (is-right-neighbor-of coord-curr coord-collision))
;                         (begin 
;                             ; (printf "double-tap 1\n")
;                             (set! coord-curr (moveUp coord-curr))
;                             ; (printf "moveUp - ~s, coll: ~s\n" coord-curr coord-collision)
;                             (set! coord-curr (moveLeft coord-curr))
;                             ; (printf "moveLeft - ~s, coll: ~s\n" coord-curr coord-collision)
;                         )]

;                     [(&& (is-below coord-curr coord-end)
;                          (is-below-neighbor-of coord-curr coord-collision))
;                         (begin 
;                             ; (printf "double-tap 2\n")
;                             (set! coord-curr (moveRight coord-curr))
;                             ; (printf "moveRight - ~s, coll: ~s\n" coord-curr coord-collision)
;                             (set! coord-curr (moveUp coord-curr))
;                             ; (printf "moveUp - ~s, coll: ~s\n" coord-curr coord-collision)
;                         )]
;                   ) 
;                   (assert (not (coord-equals coord-curr coord-collision)))
;                )
;     )
;   )
;   coord-curr
; )
; (sketch-collision-one-quad-sol 4 coord-start coord-end coord-collision)


; (define (sketch-collision-one-quad-sol-2
;           range
;           coord-start
;           coord-end
;           coord-collision)
;    (define coord-curr coord-start)
;    (for-loop (+ (* 2 range) 2)
;     (lambda () (coord-equals coord-curr coord-end))
;     (lambda ()
;       (begin
;         (cond
         
;          ((&& (is-to-right coord-curr coord-end) (not (is-right-neighbor-of coord-curr coord-collision)))
;           (begin 
;             (set! coord-curr (moveLeft coord-curr))
;             (printf "moveLeft - ~s, coll: ~s\n" coord-curr coord-collision)
;           ))
         
;          ((&& (is-below coord-curr coord-end) (not (is-below-neighbor-of coord-curr coord-collision)))
;           (begin 
;             (set! coord-curr (moveUp coord-curr))
;             (printf "moveUp - ~s, coll: ~s\n" coord-curr coord-collision)  
;           ))
         
;          ((&& (is-above coord-curr coord-end) (not (is-above coord-curr coord-collision)))
;           (begin
;             (set! coord-curr (moveUp coord-curr))
;             (printf "moveUp - ~s, coll: ~s\n" coord-curr coord-collision)
;             (set! coord-curr (moveLeft coord-curr))
;             (printf "moveLeft - ~s, coll: ~s\n" coord-curr coord-collision)
;           ))
         
;          ((&& (is-below coord-curr coord-end) (not (is-to-left coord-curr coord-collision)))
;           (begin
;             (set! coord-curr (moveRight coord-curr))
;             (printf "moveRight - ~s, coll: ~s\n" coord-curr coord-collision)
;             (set! coord-curr (moveUp coord-curr))
;             (printf "moveUp - ~s, coll: ~s\n" coord-curr coord-collision)
;           )))
        
;         (assert (not (coord-equals coord-curr coord-collision))))))
;    coord-curr)

; (sketch-collision-one-quad-sol-2 4 coord-start coord-end coord-collision)

; (define (verify-tri-2)

;     (define symbol-coord-start (fresh-sym-coord))
;     (define symbol-coord-end   (fresh-sym-coord))
;     (define symbol-coord-collision   (fresh-sym-coord))

;     (define sol (verify (checker-collision-one-quad 4 sketch-collision-one-quad-sol symbol-coord-start symbol-coord-end symbol-coord-collision)))
;     ; (define sol (verify (checker-collision 4 sketch-collision-sol symbol-coord-start symbol-coord-end symbol-coord-collision)))

;     (if (sat? sol) 
;             (begin 
;                 (printf "didn't work on following inputs:\n")
;                 (displayln sol))
;             (begin
;                 (printf "verified \n")))
; ) 
; (verify-tri-2)
; (sketch-collision-one-quad-sol 4 (list 1 1) (list (- 3) (- 3)) (list (- 3) 0))
; (checker-collision-one-quad 4 sketch-collision-one-quad-sol (list 0 0) (list 1 1) (list 0 0))

; (checker-collision-one-quad sketch-collision-one-quad-sol coord-start coord-end coord-collision)

; (destruct (append (list 0 0) (list 1 1))
;   [(list x1 y1 x2 y2)

;     (define range 7)
;     ; (define new-coord (sketch-collision-one-quad-sol range coord-start coord-end coord-collision))

;     ; this is saying that x2 <= x1 <= (x2+range)
;     (displayln (> x1 (+ x2 2)))
;     (displayln (<= x1 (+ x2 range)))
;     (displayln (> y1 (+ y2 2)))
;     (displayln (<= y1 (+ y2 range)))
;     (displayln (not (coord-equals (list 0 0) (list 0 0))))
;     (displayln (not (coord-equals (list 1 1) (list 0 0))))
    
;     ; collision must be different than start and end
;     ; (not (coord-equals coord-start coord-collision))
;     ; (not (coord-equals coord-end coord-collision))
;   ]
; )




; (sketch-collision-sol-one-quad 7 (list 7 7) (list 5 4) (list 0 0))
; (checker-collision-one-quad sketch-collision-sol-one-quad (list 7 7) (list 5 4) (list 0 0))



; (sketch-collision-sol 4 (list 0 4) (list 2 0) (list 0 1))

; (is-right-neighbor-of (list 5 5) (list 1000 10000))
; (is-left-neighbor-of (list 5 5) (list 1000 10000))
; (is-above-neighbor-of (list 5 5) (list 1000 10000))
; (is-below-neighbor-of (list 5 5) (list 1000 10000))

;
; RUNNING SOLVERS
;

; (do-synthesis-bi checker-same-bi sk-meet)
; (define range 5)
; (for ([i 9]) (begin
;     (printf "\n\n=================\n")
;     (printf "i: ~s\n" i)
;     (define time 
;         (do-synthesis-bi (curry checker-4-quads i) (curry sk-meet-4-quads i))))
    
;     (set! outer-string (string-append outer-string (~s i)))
;     (set! outer-string (string-append outer-string ","))
;     (set! outer-string (string-append outer-string (~s time)))
;     (set! outer-string (string-append outer-string "\n"))
;     (displayln outer-string)

; )

; (printf outer-string)
#|
output: 

size      time
0         303.27001953125
1         896.39990234375
2         1798.626953125
3         2294.025146484375
4         3637.976806640625
5         5059.919921875
6         6821.0400390625
7         64322.9599609375
8         104237.7080078125

size,time
0,303.27001953125
1,896.39990234375
2,1798.626953125
3,2294.025146484375
4,3637.976806640625
5,5059.919921875
6,6821.0400390625
7,64322.9599609375
8,104237.7080078125

|#

#|
(define (sk-meet-4-quads range coord-start coord-end)
  (define coord-curr coord-start)
  (for-loop 14
    (lambda () (coord-equals coord-curr coord-end))
    (lambda () (cond
        [(is-above coord-curr coord-end)
            (set! coord-curr (moveUp coord-curr))]
        [(is-to-left coord-curr coord-end)
            (set! coord-curr (moveRight coord-curr))]
        [(is-below coord-curr coord-end)
            (set! coord-curr (moveDown coord-curr))]
        [(is-to-right coord-curr coord-end)
            (set! coord-curr (moveLeft coord-curr))
        ])))
  coord-curr
)

(define (sk-meet-4-quads range coord-start coord-end)
   (define coord-curr coord-start)
   (for-loop
    (* 2 range)
    (lambda () (coord-equals coord-curr coord-end))
    (lambda ()
      (cond
       ((is-above coord-curr coord-end) (set! coord-curr (moveUp coord-curr)))
       ((is-to-left coord-curr coord-end)
        (set! coord-curr (moveRight coord-curr)))
       ((is-below coord-curr coord-end) (set! coord-curr (moveDown coord-curr)))
       ((is-to-right coord-curr coord-end)
        (set! coord-curr (moveLeft coord-curr))))))
   coord-curr)

|#


#|
SOLUTION:

(define (sk-meet coord-start coord-end)
   (define coord-curr coord-start)
   (for-loop
    7
    (lambda () (same-x coord-curr coord-end))
    (lambda () (set! coord-curr (moveRight coord-curr))))
   (for-loop
    7
    (lambda () (same-y coord-curr coord-end))
    (lambda () (set! coord-curr (moveDown coord-curr))))
   coord-curr)










(define (sk-meet-4-quads range coord-start coord-end)
  (define coord-curr coord-start)
  (for-loop 14
    (lambda () (coord-equals coord-curr coord-end))
    (lambda () (cond
        [(is-down coord-curr coord-end)
            (set! coord-curr (moveUp coord-curr))]
        [(is-to-left coord-curr coord-end)
            (set! coord-curr (moveRight coord-curr))]
        [(is-up coord-curr coord-end)
            (set! coord-curr (moveDown coord-curr))]
        [(is-to-right coord-curr coord-end)
            (set! coord-curr (moveLeft coord-curr))
        ])))
  coord-curr
)


(define (move-diagonally coord)
   (define coord1 (moveLeft coord))
   (define coord2 (moveLeft coord1))
   (define coord3 (moveLeft coord2))
   (define coord4 (moveUp coord3))
   (define coord5 (moveUp coord4))
   (define coord6 (moveUp coord5))
   coord6)
(moveLeft (moveLeft (moveLeft (moveUp (moveUp (moveUp coord))))))
|#
