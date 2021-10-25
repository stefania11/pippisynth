#lang rosette

(require rosette/lib/synthax)
(require json)

;; Read in a file from `/tests/`
(define (get-tests-file-path file-name)
 (build-path (current-directory) ".." "tests" file-name))

;; Get the blocks hash from a project
;; TODO: this assumes a particular structure is always present...is it?
;;       in particular, do I always lookup targets, then take the second entry, and
;;       then lookup blocks?
(define (get-blocks-from-project file)
  (hash-ref (second (hash-ref file 'targets)) 'blocks))

;; Determines if this is a start block
;; TODO: is this always unique? Is this always the same block ("event_whenflagclicked")?
;;       or can it be a different opcode?
(define (is-start-block block)
  (string=? (hash-ref block 'opcode) "event_whenflagclicked" ))

;; Get the initial block
(define (get-start-block blocks)
  (first (filter (λ (key) (is-start-block (hash-ref blocks key))) (hash-keys blocks))))

;; get block's next block, or nil if none
;; Parameters:
;; ===========
;; blocks: the hasheq from block keys block hasheqs
;; block: the actual block hasheq
(define (get-next-block blocks block)
  ;; NOTE: I need to transform strings to symbols, since keys are stored as both
  ;; strings and symbols in json files. There is probably a nicer way to do
  ;; this, but for now this is fine.
  (hash-ref blocks (string->symbol (hash-ref block 'next))))

(define (get-input-blocks blocks block)
  (for/list ([ip (hash-ref 'inputs block)])
    (hash-ref blocks )))

;; A test file for debugging/development
(define test-file (call-with-input-file (get-tests-file-path "random-number.json") read-json))
(define test-blocks (get-blocks-from-project test-file))
(define start-block-key (get-start-block test-blocks))
(define start-block (hash-ref test-blocks start-block-key))
;;; We can use `get-next-block to get the next block in the program
(define second-block (get-next-block test-blocks start-block))
(define third-block  (get-next-block test-blocks second-block))
