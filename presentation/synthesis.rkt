#lang rosette
(require rosette/lib/synthax   rosette/lib/destruct)     ; Require the sketching library.
(require racket/match)

(provide 
    do-synthesis-bi
    do-synthesis
)

; creates new symbolic coordinate
(define (fresh-sym-coord) 
  (define-symbolic* x y integer?)
  (list x y))

; for programs with 1 coordinate inputs
(define (do-synthesis checker sketch)

    (newline)
    (define symbol-coord (fresh-sym-coord))

    (define sol
      (synthesize
              #:forall symbol-coord
              #:guarantee (checker sketch symbol-coord)))
    
    (if (sat? sol) 
            (begin 
                (printf "solution:\n")
                (print-forms sol))
            (begin
                (printf "no solution found\n")))
) 

; for programs with 2 coordinate inputs
(define (do-synthesis-bi checker sketch)

    (newline)
    (define symbol-coord-start (fresh-sym-coord))
    (define symbol-coord-end   (fresh-sym-coord))

    (define sol
      (synthesize
              #:forall (list symbol-coord-start symbol-coord-end)
              #:guarantee (checker sketch symbol-coord-start symbol-coord-end)))

    (if (sat? sol) 
            (begin 
                (printf "solution:\n")
                (print-forms sol))
            (begin
                (printf "no solution found\n")))
) 
