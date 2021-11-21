#lang rosette
(require rosette/lib/synthax)     ; Require the sketching library.
(require racket/match)
(error-print-width 10000000000)
; (output-smt #t)


; GRAMMAR
(define-grammar (simple x)
  [expr
   (choose 
        1 
        (+ x (expr))
        (- x (expr))
    )])


(define-symbolic sym-x integer?)



(define (sk1 x)
  (simple x #:depth 1))

; (displayln (sk1 sym-x))

#|
(ite* 
    (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:20:3 1) 
    (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:20:3 
            (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:20:3)) 
        (+ 1 sym-x)) 
    (⊢ (&& 
            (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:20:3) 
            (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:20:3)) 
        (+ -1 sym-x)))
|#


(define (sk2 x0)
    (define x1 (simple x0   #:depth 1))
    (define x2 (simple x1   #:depth 1)) 
    x2
)

; (displayln (sk2 sym-x))

#|

(model
 [0$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:41:16 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:41:16 #t]
 [0$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:41:16 #t]
 [1$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:41:16 #f]
 [0$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:41:16 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:41:16 #f]
 [0$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:42:16 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:42:16 #t]
 [0$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:42:16 #t]
 [1$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:42:16 #f]
 [0$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:42:16 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:42:16 #f])

(ite* 
    (⊢ var1 1) 
    (⊢ (&& 
            var2 
            (! var1)) 
        (+ 1 (ite* 
                (⊢ var3 1) 
                (⊢ (&& var4 
                        (! var3)) 
                    (+ 1 sym-x)) 
                (⊢ (&& 
                        (! var3) 
                        (! var4)) 
                    (+ -1 sym-x))))) 
    (⊢ (&& 
            (! var1) 
            (! var2)) 
        (+ -1 (ite* 
                (⊢ var3 1) 
                (⊢ (&& 
                        var4 
                        (! var3)) 
                    (+ 1 sym-x)) 
                (⊢ (&& 
                        (! var3) 
                        (! var4)) 
                    (+ -1 sym-x))))))
|#

(define (sk3 x)
    (simple (simple x #:depth 1) #:depth 1)
)

; (displayln (sk3 sym-x))

#|

(model
 [0$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #t]
 [0$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #t]
 [0$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #t]
 [1$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [0$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [0$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #t]
 [1$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [0$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [0$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [0$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [0$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [0$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [0$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:13:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [0$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f]
 [1$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:13$choose:small-grammar:11:4$expr:small-grammar:14:14$choose:small-grammar:11:4$expr:small-grammar:10:3$simple:small-grammar:79:5 #f])

(ite* 
    (⊢ var1 1) 
    (⊢ (&& 
            var2 
            (! var1)) 
        (+ 1 (ite* 
                (⊢ var3 1) 
                (⊢ (&& 
                        var4 
                        (! var3)) 
                    (+ 1 sym-x)) 
                (⊢ (&& 
                        (! var3) 
                        (! var4)) 
                    (+ -1 sym-x))))) 
    (⊢ (&& 
            (! var1) 
            (! var2)) 
        (+ -1 (ite* 
                (⊢ var3 1) 
                (⊢ (&& 
                        var4 
                        (! var3)) 
                    (+ 1 sym-x)) 
                (⊢ (&& 
                        (! var3) 
                        (! var4)) 
                    (+ -1 sym-x))))))
|#


(define (sk4 x0)
    (define x1 (simple x0   #:depth 1)) 
    (define x2 (simple x1   #:depth 1)) 
    (define x3 (simple x2   #:depth 1)) 
    x3
)

; (displayln (sk4 sym-x))

#|
(ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:42:16 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:42:16 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:42:16)) (+ 1 (ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:41:16 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:41:16 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:41:16)) (+ 1 (ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16)) (+ 1 sym-x)) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16)) (+ -1 sym-x))))) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:41:16) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:41:16)) (+ -1 (ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16)) (+ 1 sym-x)) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16)) (+ -1 sym-x)))))))) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:42:16) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:42:16)) (+ -1 (ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:41:16 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:41:16 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:41:16)) (+ 1 (ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16)) (+ 1 sym-x)) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16)) (+ -1 sym-x))))) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:41:16) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:41:16)) (+ -1 (ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16)) (+ 1 sym-x)) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:40:16)) (+ -1 sym-x)))))))))
|#

(define (sk5 x)
    (simple (simple (simple x #:depth 1) #:depth 1) #:depth 1)
)

; (displayln (sk5 sym-x))

#|
(ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ 1 (ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ 1 (ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ 1 sym-x)) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ -1 sym-x))))) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ -1 (ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ 1 sym-x)) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ -1 sym-x)))))))) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ -1 (ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ 1 (ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ 1 sym-x)) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ -1 sym-x))))) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ -1 (ite* (⊢ 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 1) (⊢ (&& 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5 (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ 1 sym-x)) (⊢ (&& (! 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5) (! 1$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:49:5)) (+ -1 sym-x)))))))))
|#


(define (wow sketch num)
    (define-symbolic* sym-x integer?)

    (define before (current-inexact-milliseconds))
    (displayln (vc))
    (define sol-same (synthesize
        #:forall sym-x
        #:guarantee (begin
                        (assert (= (sketch sym-x) (+ sym-x num)))   
                        (displayln (vc))
                    )
    ))
    (displayln (vc))
    (define after (current-inexact-milliseconds))
    (define time (- after before))
    (printf "\n\n=================\n")
    (if (sat? sol-same) 
            (begin 
                (printf "solution:\n")
                ; (displayln sol-same)
                (print-forms sol-same))
            (begin
                (printf "no solution found\n")))
    (printf "\n***** time: ~s milliseconds\n" time)
)


; (wow sk1 1)
; (wow sk2 2)
(wow sk3 2)
; (wow sk4 3)
; (wow sk5 3)

; (define (sk3 x0) 
;     (define x1 1) 
;     (define x2 (+ x1 1)) 
;     (define x3 (+ x2 1)) 
;     x3)
                
#|
(ite 0$choose:small-grammar:9:4$expr:small-grammar:8:3$simple:small-grammar:14:3 1 5)
(ite 
    0$choose:small-grammar:9:4$expr:small-grammar:8:3$simple:small-grammar:27:16 
    1 
    (ite 
        0$choose:small-grammar:9:4$expr:small-grammar:8:3$simple:small-grammar:26:16 
            2 
            6))
(ite 
    0$choose:small-grammar:9:4$expr:small-grammar:8:3$simple:small-grammar:19:5 
    1 
    (ite 
        0$choose:small-grammar:9:4$expr:small-grammar:8:3$simple:small-grammar:19:13$choose:small-grammar:9:4$expr:small-grammar:8:3$simple:small-grammar:19:5 
        2 
        6))


(ite 
    0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:37:16 
    1 
    (+ 1 (ite 
            0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:36:16 
            1 
            (ite 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:35:16 
                2 
                6))))

(ite 
    0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:44:5 
    1 
    (+ 1 (ite 
        0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:44:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:44:5 
        1 (ite 0$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:44:21$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:44:13$choose:small-grammar:10:4$expr:small-grammar:9:3$simple:small-grammar:44:5 
                2 
                6))))
|#