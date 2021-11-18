racket_filename = "output-files/generated-racket-files/emina-trial-decision-vars.rkt"
file_string = ""

def eminaHeader():
    global file_string
    file_string += "#lang rosette\n" + \
            "\n" + \
            "(require rosette/lib/angelic rosette/lib/destruct)\n" + \
            "(require 2htdp/batch-io)\n" + \
            "(output-smt #t)\n" + \
            "(require racket/sandbox)\n" + \
            "\n" + \
            "(struct point (x y) #:transparent)\n" + \
            "\n" + \
            "(define (moveUp coord)\n" + \
            "  (destruct coord\n" + \
            "    [(point x y) (point x (- y 1))]))\n" + \
            "\n" + \
            "(define (moveDown coord)\n" + \
            "  (destruct coord\n" + \
            "    [(point x y) (point x (+ y 1))]))\n" + \
            "\n" + \
            "(define (moveLeft coord)\n" + \
            "  (destruct coord\n" + \
            "    [(point x y) (point (- x 1) y)]))\n" + \
            "\n" + \
            "(define (moveRight coord)\n" + \
            "  (destruct coord\n" + \
            "    [(point x y) (point (+ x 1) y)]))\n" + \
            "\n" + \
            "(define (nop coord) coord)\n" + \
            "\n" + \
            "; Deep embedding where operators are the functions\n" + \
            "; nop, moveUp, moveDown, moveLeft, moveRight.\n" + \
            "(define (interpret ops coord)\n" + \
            "  (if (null? ops)\n" + \
            "      coord\n" + \
            "      (interpret (cdr ops) ((car ops) coord))))\n" + \
            "\n" + \
            "; Now, synthesizing a program involves picking a list of\n" + \
            "; functions rather than having to construct a nested expression.\n" + \
            "(define (sym-op)\n" + \
            "  (choose*\n" + \
            "   nop moveUp moveDown\n" + \
            "   moveLeft moveRight))\n" + \
            "\n(define-symbolic* x y integer?)\n" + \
            "(define in (point x y))\n\n" + \
            "(define outer-string \"\")\n" + \
            "(set! outer-string (string-append outer-string \"type,size,time,program\\n\"))\n"


def eminaWayFunction(n):
    global file_string
    assert(n % 2 == 0)
    file_string += "\n\n; ------------------ \n(printf \"\\n\\nprog " + str(n) + " emina way: \\n\")\n"

    file_string += "(define prog" + str(n) + " (list\n"
    for j in range(n):
        file_string += "  (sym-op)\n"
    
    file_string += ")) \n\n"
    file_string += "(define sol" + str(n) + "\n" + \
        "  (synthesize\n" + \
        "     #:forall in\n" + \
        "     #:guarantee\n" + \
        "     (let ([out (interpret prog" + str(n) + " in)])\n" + \
        "       (assert (= (point-x out) (- (point-x in) " + str(n//2) + ")))\n" + \
        "       (assert (= (point-y out) (- (point-y in) " + str(n//2) + "))))))\n" + \
        "\n"
    file_string += "(evaluate prog" + str(n) + " sol" + str(n) + ")\n" 


def doItAll():
    global file_string
    eminaHeader()
    eminaWayFunction(2)
    eminaWayFunction(4)
    eminaWayFunction(6)
    # eminaWayFunction(8)
    # eminaWayFunction(10)
    # eminaWayFunction(12)
    # eminaWayFunction(14)
    # eminaWayFunction(16)
    # eminaWayFunction(18)
    # eminaWayFunction(20)
    # eminaWayFunction(22)
    # eminaWayFunction(24)
    # eminaWayFunction(26)
    with open(racket_filename, "w") as file:
        file.write(file_string)
    

doItAll()
