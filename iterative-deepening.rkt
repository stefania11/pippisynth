#lang rosette
(require rosette/lib/synthax)     ; Require the sketching library.
(require racket/match)


(provide 
  iterative-deepening
)


(define-symbolic x y integer?) 
(define symbol-coord (list x y))

(define (iterative-deepening checker program)
    (define it-depth 0)
    (for ([i 100] #:break (= it-depth -1))
        (define sol-same
        (synthesize
            #:forall symbol-coord
            #:guarantee (checker it-depth program symbol-coord)))
        (if (sat? sol-same)
        (begin 
            (printf "solution found at it-depth ~s\n" it-depth)
            (printf "solution:\n")
            (print-forms sol-same)
            (set! it-depth -1))
        (begin
            (printf "no solution found at it-depth ~s\n" it-depth)
            (set! it-depth (+ it-depth 1))))))