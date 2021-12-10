# PippiSynth: CSE 507 Final Project

There are 5 examples that we set up that are able to be run. They are each in their own files and can be run independently. 

## System Requirements

In order to run these examples, you need to have [Racket](https://download.racket-lang.org/) and [Rosette](https://github.com/emina/rosette) installed. Other than that, everything should be self contained in the files in this repo. 

## File Organization

### DSL Files:
* `moving-grammar.rkt`: contains the grammars `moving` and `bi-conditional`, as well as the functions that these grammars are made up of

* `for-loop.rkt`: contains our custom `for-loop` function

* `synthesis.rkt`: contains 2 wrappers for calls to Rosette's `synthesize` - `do-synthesis` which takes in checkers/sketches that take in 1 coordinate, and `do-synthesis-bi` which takes in checkers/sketches that take in 2 coordinates

### Example Files

* `1-move-left.rkt`: contains example of a simple program that aims to move a coordinate once to the left

* `2-move-diagonally.rkt`: contains example for a program that moves a coordinate along a diagonal of size 3

* `3-move-diagonally-loop.rkt`: contains example for a program that moves a coordinate along a diagonal of size 3 *with a loop*

* `4-meeting-one-quad.rkt`: contains example for a program that moves 1 coordinate to another coordinate in only 1 quadrant of the board

* `5-meeting-four-quads.rkt`: contains example for a program that moves 1 coordinate to another coordinate in any of the 4 quadrants

* `presentation-all.rkt`: contains all examples in 1 file, to be run all at once (if desired)


## How To Run

There are 5 examples. Refer to previous section to see what they are. 

In order to run the examples, first navigate to this folder in your terminal. `ls` output should look like:

```
$ ls
1-move-left.rkt            3-move-diagonally-loop.rkt 5-meeting-four-quads.rkt   for-loop.rkt               presentation-all.rkt
2-move-diagonally.rkt      4-meeting-one-quad.rkt     README.md                  moving-grammar.rkt         synthesis.rkt
```

Then, make sure you have Racket installed. We used Racket v8.2, and cannot confirm our code works on any other version. 

```
$ racket --version
Welcome to Racket v8.2 [cs].
```

Finally, run the examples with syntax `racket fileName.rkt`. Example:

```
$ racket 1-move-left.rkt

solution:
/Users/darya/Code/CSE507/pippisynth/presentation/1-move-left.rkt:20:0
'(define (move-left coord) (moveLeft coord))
```

If you wish to run all examples at once, you can also run `presentation-all.rkt`:

```
$ racket presentation-all.rkt

solution:
/Users/darya/Code/CSE507/pippisynth/presentation/1-move-left.rkt:20:0
'(define (move-left coord) (moveLeft coord))

solution:
/Users/darya/Code/CSE507/pippisynth/presentation/2-move-diagonally.rkt:20:0
'(define (move-diagonally coord)
   (define coord1 (moveLeft coord))
   (define coord2 (moveLeft coord1))
   (define coord3 (moveLeft coord2))
   (define coord4 (moveUp coord3))
   (define coord5 (moveUp coord4))
   (define coord6 (moveUp coord5))
   coord6)

...
```
