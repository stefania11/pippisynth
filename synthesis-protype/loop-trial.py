def loop(depth, n):
    lines = []
    starter_line = "\n\n(define (curr-ex-" + str(n) + " coord0 depth)"
    lines.append(starter_line)
    print(starter_line)
    for i in range(1, depth+1):
        new_str = "  (define coord" + str(i) + " (moving coord" + str(i-1) + " #:depth 1))"
        lines.append(new_str)
        print(new_str)
    last_line = "  coord" + str(depth) + ")"
    lines.append(last_line)
    print(last_line)
    
    return lines

def deepen(depth, n):
    for i in range(depth):
        loop(i, n+i)

deepen(5, 5)