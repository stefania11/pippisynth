#lang rosette/safe

(require
  rosette/lib/synthax
  rosette/lib/destruct
  racket/match
)

(require 
  "moving-grammar.rkt" 
  "for-loop.rkt"
  "synthesis.rkt"
  "1-move-left.rkt"
  "2-move-diagonally.rkt"
  "3-move-diagonally-loop.rkt"
  "4-meeting-one-quad.rkt"
  "5-meeting-four-quads.rkt"
)

; require statement runs them all at once haha
; no need to run them here also

;
; move once
;
; (do-synthesis check-left move-left)

;
; move diagonally
;
; (do-synthesis check-diagonal move-diagonally)

;
; move diagonally loop
;
; (do-synthesis check-diagonal-loop move-diagonally-loop)

;
; meeting one quad
;
; (do-synthesis-bi checker-one-quad meeting-one-quad)

;
; meeting 4 quads
;
; (do-synthesis-bi checker-four-quads meeting-four-quads)
