darya_files = [ ]

ras_files = [ ]

emina_files = [ ]
         
numbers = [ 2 , 4 , 6 , 8 , 10 , 12 , 14 , 16 , 18 , 20 ]

darya_output = "output-files/decision-vars-output/darya-output.txt"
ras_output = "output-files/decision-vars-output/ras-output.txt"
emina_output = "output-files/decision-vars-output/emina-output.txt"

csv_output_file = "output-files/decision-vars-output/decision-vars.csv"

output_string = "name,size,# decision vars\n"

def count(files): 
    for file_name in files:
        file = open(file_name, "r")
        lines = count_lines(file)
        print(file_name, ", ", lines)


def filter_files():
    for file_name in darya_files:
        file = open(file_name, "r")
        contents = file.read()
        if not ("define-fun" in contents or "declare-fun" in contents):
            darya_files.remove(file_name)
    
    for file_name in ras_files:
        file = open(file_name, "r")
        contents = file.read()
        if not ("define-fun" in contents or "declare-fun" in contents):
            ras_files.remove(file_name)

    for file_name in emina_files:
        file = open(file_name, "r")
        contents = file.read()
        if not ("define-fun" in contents or "declare-fun" in contents):
            emina_files.remove(file_name)


def count_lines():
    global output_string
    for fileIndex in range(len(darya_files)):
        file_name = darya_files[fileIndex]
        file = open(file_name, "r")
        count = count_lines_file(file)
        output_string += "darya," + str(numbers[fileIndex]) + "," + str(count) + "\n"
    
    for fileIndex in range(len(ras_files)):
        file_name = ras_files[fileIndex]
        file = open(file_name, "r")
        count = count_lines_file(file)
        output_string += "ras," + str(numbers[fileIndex]) + "," + str(count) + "\n"

    for fileIndex in range(len(emina_files)):
        file_name = emina_files[fileIndex]
        file = open(file_name, "r")
        count = count_lines_file(file)
        output_string += "emina," + str(numbers[fileIndex]) + "," + str(count) + "\n"


def count_lines_file(file):
    content = file.read()
    contents = content.split("\n")
    counter = 0 
    for line in contents:
        if line:
            if not (("assert" in line) or ("check-sat" in line) or ("get-model" in line) or ("reset" in line) or ("set-option" in line)):
                counter += 1

    return counter

def get_file_names():
    darya_file = open(darya_output, "r")
    content_darya = darya_file.read()
    contents_darya = content_darya.split("\n")
    for line_darya in contents_darya:
        if ("Outputting SMT to file: " in line_darya):
            darya_files.append(line_darya[len("Outputting SMT to file: "):])
    
    ras_file = open(ras_output, "r")
    content_ras = ras_file.read()
    contents_ras = content_ras.split("\n")
    for line_ras in contents_ras:
        if ("Outputting SMT to file: " in line_ras):
            new_file_name = line_ras[len("Outputting SMT to file: "):]
            ras_files.append(new_file_name)
    
    emina_file = open(emina_output, "r")
    content_emina = emina_file.read()
    contents_emina = content_emina.split("\n")
    for line_emina in contents_emina:
        if ("Outputting SMT to file: " in line_emina):
            emina_files.append(line_emina[len("Outputting SMT to file: "):])
    

def doAll():
    get_file_names()
    filter_files()
    count_lines()
    with open(csv_output_file, "w") as file:
        file.write(output_string)

doAll()