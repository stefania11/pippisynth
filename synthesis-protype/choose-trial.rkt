#lang rosette
(require rosette/lib/synthax)     ; Require the sketching library.
(require racket/match)

(define (bvmul2_choose x)
    ((choose bvashr bvshl bvlshr) x (?? (bitvector 8))))

(define-symbolic x (bitvector 8))
(bvmul2_choose x)

(define sol
    (synthesize
     #:forall (list x)
     #:guarantee (assert (equal? (bvmul2_choose x) (bvmul x (bv 2 8))))))

sol
(print-forms sol)

#|

choose bvshl bvashr bvlshr

(ite* 
    (⊢ 0$choose:choose-trial:6:6 (bvshl x ??:choose-trial:6:37)) 
    (⊢ 
        (&& 1$choose:choose-trial:6:6 (! 0$choose:choose-trial:6:6)) 
        (bvashr x ??:choose-trial:6:37)) 
    (⊢ 
        (&& (! 0$choose:choose-trial:6:6) 
        (! 1$choose:choose-trial:6:6)) 
        (bvlshr x ??:choose-trial:6:37)))
|#


; (render-value/snip wow1)
; (define wow1_string0 (string-replace (~s wow1) "0$choose:basic-synthesis-prototype:31:4$expr:basic-synthesis-prototype:30:3$moving:basic-synthesis-prototype:87:3" "thing0"))
; (define wow1_string1 (string-replace (~s wow1_string0) "1$choose:basic-synthesis-prototype:31:4$expr:basic-synthesis-prototype:30:3$moving:basic-synthesis-prototype:87:3" "thing1"))
; (define wow1_string2 (string-replace (~s wow1_string1) "2$choose:basic-synthesis-prototype:31:4$expr:basic-synthesis-prototype:30:3$moving:basic-synthesis-prototype:87:3" "thing2"))
; (define wow1_string3 (string-replace (~s wow1_string2) "3$choose:basic-synthesis-prototype:31:4$expr:basic-synthesis-prototype:30:3$moving:basic-synthesis-prototype:87:3" "thing3"))
; (pretty-print wow1_string3)


; wow0
; wow1
; wow2
; wow3
; wow4

; (pretty-print wow0)
; (pretty-print wow1)

; (printf "wow0:\n")
; (for ([x wow0])
;     (printf "\t* ~s\n" x))

; (printf "wow1:\n")
; (for ([x wow1])
;     (printf "\t* ~s\n" x))


; sol-same
; (print-forms sol-same)
; solution: (define (same-coord coord) coord)

; (define depth 0)
; (for ([i 100] #:break (= depth -1))
;     (define sol-same
;       (synthesize
;         #:forall symbol-coord
;         #:guarantee (checker-test depth same-coord symbol-coord)))
;     (if (sat? sol-same)
;       (begin 
;         (printf "solution found at depth ~s\n" depth)
;         (printf "solution:\n")
;         (print-forms sol-same)
;         (set! depth -1))
;       (set! depth (+ depth 1))))


; (define (same-coord-num coord depth)
;   (moving coord #:depth depth))

; (define wow0 (same-coord-num (list 1000 2000) 0))
; (define wow1 (same-coord-num (list 1000 2000) 1))
; (define wow2 (same-coord-num (list 1000 2000) 2))
; (define wow3 (same-coord-num (list 1000 2000) 3))
; (define wow4 (same-coord-num (list 1000 2000) 4))

