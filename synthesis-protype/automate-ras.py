racket_filename = "output-files/ras-trial.rkt"
data_filename = "\"output-files/ras.csv\""

def rasHeader(file_string):
    file_string += "#lang rosette\n" + \
                "(require rosette/lib/synthax)     ; Require the sketching library.\n" + \
                "(require racket/match)\n" + \
                "(require 2htdp/batch-io)\n" + \
                "(error-print-width 10000000000)\n" + \
                "(require \n" + \
                "  \"../moving-grammar.rkt\"\n" + \
                ")\n" + \
                "\n" + \
                "(define-symbolic* x y integer?) \n" + \
                "(define symbol-coord (list x y))\n" + \
                "\n" + \
                "\n" + \
                "(define (checker n impl coord)\n" + \
                "  (match coord\n" + \
                "    [(list x y)\n" + \
                "     (define new-coord (impl coord))\n" + \
                "     (define new-x (list-ref new-coord 0))\n" + \
                "     (define new-y (list-ref new-coord 1))\n" + \
                "     (assert (= (- x n) new-x))\n" + \
                "     (assert (= (- y n) new-y))]))\n" + \
                "\n"+ \
                "(define outer-string \"\")\n" + \
                "(set! outer-string (string-append outer-string \"type,size,time,program\\n\"))\n"
    return file_string

def rasWayFunction(n, file_string):
    assert(n % 2 == 0)
    file_string += "(define (prog-sketch" + str(n) + " coord0)" + "\n"
    for i in range(1, n+1):
        file_string += "  (define coord" + str(i) + " (moving coord" + str(i-1)+"   #:depth 1)) " + "\n"

    file_string += "  coord" + str(n) + "\n"
    file_string += ")" + "\n"
    file_string += "(define before" + str(n) + " (current-inexact-milliseconds))" + "\n"
    file_string += "\n(define sol" + str(n) + "\n" + \
            "  (synthesize\n" + \
            "      #:forall symbol-coord\n" + \
            "      #:guarantee ((curry checker " + str(n//2) + ") prog-sketch" + str(n) + " symbol-coord)))\n" + \
            "\n" + "\n"
    file_string += "(define after" + str(n) + " (current-inexact-milliseconds))\n"
    file_string += "(define time" + str(n) + " (- after" + str(n) + " before" + str(n) + "))\n"
    file_string += "(set! outer-string (string-append outer-string \"ras," + str(n) + ",\"))\n"
    file_string += "(set! outer-string (string-append outer-string (~s time" + str(n) + ")))\n"
    # TODO add back in when i figure out how to get result of print-forms
    # file_string += "(set! outer-string (string-append outer-string \",\"))\n"    
    # file_string += "(set! outer-string (string-append outer-string (~s (print-forms sol" + str(n) + "))))\n" 
    file_string += "(set! outer-string (string-append outer-string \"\\n\"))\n"    
    return file_string

def doItAll():
    file_string = rasHeader("")
    # file_string = rasWayFunction(4, file_string)
    # file_string = rasWayFunction(6, file_string)
    # file_string = rasWayFunction(8, file_string)
    # file_string = rasWayFunction(10, file_string)
    # file_string = rasWayFunction(12, file_string)
    # file_string = rasWayFunction(14, file_string)
    # file_string = rasWayFunction(16, file_string)
    # file_string = rasWayFunction(18, file_string)
    file_string = rasWayFunction(20, file_string)
    file_string += "(write-file " + data_filename + " outer-string)\n"
    with open(racket_filename, "w") as file:
        file.write(file_string)


doItAll()