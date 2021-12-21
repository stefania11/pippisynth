# Pippisynth
Class project for AUT 21 [CSE 507 Computer-Aided Reasoning for Software](https://courses.cs.washington.edu/courses/cse507/21au/)

Our project's main goal is to synthesize programs that represent video-games given a dedicated grammar and constraints derived from specific game mechanics or from user-input.

To this end, we will build a minimal domain-specific language (DSL) in Rosette which includes simple grammars for motion, collisions, conditionals, and loops. To specify what behavior we want our synthesized programs to have, we offer the solver a set of rules that minimally describe the desired constraints on the program (e.g., specify that we want a character to move up five steps and three steps to the left, or that we don't want it to collide with another character on its way to another destination). This comes in the form of either example, a reference implementation, or a set of boolean constraints on the different states of the game characters.


# Codestyle 

## Example of grammar function 

```
(define-grammar (sameCoord coord1 coord2)
    [expr
        (choose (same-x coord1 coord2)
                (same-y coord1 coord2)
        )
    ]
)
```

## Example of checker function 

```
(define (check-same depth impl coord)
  (match coord
    [(list x y)
     (define new-coord (impl coord depth))
     (define new-x (list-ref new-coord 0))
     (define new-y (list-ref new-coord 1))
     (assert (= x new-x))
     (assert (= y new-y))]))
```
## Example of solver function 

```
(define (same-x coord1 coord2)
  (destruct (append coord1 coord2)
    [(list x y x2 y2)
      (= x x2)]))
```

## Example of sketch 

```
(define (sk-meet coord-start coord-end)
  (define coord-curr coord-start)
  (for-loop 7
    (lambda () (sameCoord coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  (for-loop 7
    (lambda () (sameCoord coord-curr coord-end #:depth 1))
    (lambda () (set! coord-curr (moving coord-curr #:depth 1))))
  coord-curr
)
```
