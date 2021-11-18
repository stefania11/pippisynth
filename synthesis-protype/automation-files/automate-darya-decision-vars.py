racket_filename = "output-files/generated-racket-files/darya-trial-decision-vars.rkt"
file_string = ""

def daryaHeader():
    global file_string
    file_string += "#lang rosette\n" + \
        "(require rosette/lib/synthax)     ; Require the sketching library.\n" + \
        "(require racket/match)\n" + \
        "(output-smt #t)\n" + \
        "(error-print-width 10000000000)\n" + \
        "(require dyoo-while-loop)\n" + \
        "(require \n" + \
        "  \"../../moving-grammar.rkt\" \n" + \
        ")\n" + \
        "(require racket/sandbox)\n" + \
        "\n" + \
        "(define (checker n depth impl coord)\n" + \
        "  (match coord\n" + \
        "    [(list x y)\n" + \
        "     (define new-coord (impl coord depth))\n" + \
        "     (define new-x (list-ref new-coord 0))\n" + \
        "     (define new-y (list-ref new-coord 1))\n" + \
        "     (assert (= (- x n) new-x))\n" + \
        "     (assert (= (- y n) new-y))]))\n" + \
        "\n" + \
        "(define-symbolic x y integer?) \n" + \
        "(define symbol-coord (list x y))\n" + \
        "\n" + \
        "(define (run-checker checker program prog-depth)\n" + \
        "  (with-deep-time-limit 50\n" + \
        "    (define sol\n" + \
        "      (synthesize\n" + \
        "                #:forall symbol-coord\n" + \
        "                #:guarantee (checker prog-depth program symbol-coord)))\n" + \
        "    (print-forms sol)\n" + \
        "  )\n" + \
        ")\n" + \
        "\n" 


def daryaWayFunction(n):
    global file_string
    assert(n % 2 == 0)
    file_string += "\n\n; ------------------ \n(printf \"\\n\\nprog " + str(n) + " darya way: \\n\")\n"

    file_string += "(define (sketch" + str(n) + " coord sketch-depth)\n"
    file_string += "\t(moving coord #:depth sketch-depth))\n"
    
    file_string += "\n"
    file_string += "(run-checker (curry checker " + str(n//2) + ") sketch" + str(n) + " " + str(n) + ")\n"


def doItAll():
    daryaHeader()
    daryaWayFunction(2)
    daryaWayFunction(4)
    daryaWayFunction(6)
    # daryaWayFunction(8)
    # daryaWayFunction(10)
    # daryaWayFunction(12)
    # daryaWayFunction(14)
    # daryaWayFunction(16)
    # daryaWayFunction(18)
    # daryaWayFunction(20)
    # daryaWayFunction(22)
    # daryaWayFunction(24)
    # daryaWayFunction(26)
    with open(racket_filename, "w") as file:
        file.write(file_string)
    

doItAll()
