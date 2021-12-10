#lang rosette
(require rosette/lib/synthax   rosette/lib/destruct)     ; Require the sketching library.
(require racket/match)


(provide 
  moveLeft
  moveRight
  moveUp
  moveDown
  moving
  coord-equals
  same-x 
  same-y 
  is-to-right 
  is-to-left 
  is-below 
  is-above 
  bi-conditional 
)


; DEFINITIONS
(define (moveLeft coord)
  (match coord
    [(list x y) (list (- x 1) y)]
    [_ "error wrong format for coordinate"]))

(define (moveRight coord)
  (match coord
    [(list x y) (list (+ x 1) y)]
    [_ "error wrong format for coordinate"]))

(define (moveUp coord)
  (match coord
    [(list x y) (list x (- y 1))]
    [_ "error wrong format for coordinate"]))

(define (moveDown coord)
  (match coord
    [(list x y) (list x (+ y 1))]
    [_ "error wrong format for coordinate"]))

; GRAMMAR
(define-grammar (moving coord)
  [expr
   (choose coord
           (moveUp (expr))
           (moveLeft (expr))
           (moveDown (expr))
           (moveRight (expr)))])




;
; Coordinate stuff
;
(define (coord-equals coord coord2)
  (destruct (append coord coord2)
    [(list x y x2 y2)
     (and (= x x2)
          (= y y2))]))

(define (same-x coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x y x2 y2)
      (= x x2)]))

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


;
; Conditional grammar
;

(define-grammar (bi-conditional coord1 coord2)
    [expr
        (choose 
                (same-x coord1 coord2)
                (same-y coord1 coord2)

                (is-to-right coord1 coord2)
                (is-to-left coord1 coord2)
                (is-below coord1 coord2)
                (is-above coord1 coord2)
        )
    ]
)
