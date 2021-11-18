#! bash
set -v

python3 automation-files/automate-emina-decision-vars.py
python3 automation-files/automate-ras-decision-vars.py
python3 automation-files/automate-darya-decision-vars.py

racket output-files/generated-racket-files/darya-trial-decision-vars.rkt &> output-files/decision-vars-output/darya-output.txt
racket output-files/generated-racket-files/ras-trial-decision-vars.rkt &> output-files/decision-vars-output/ras-output.txt
racket output-files/generated-racket-files/emina-trial-decision-vars.rkt &> output-files/decision-vars-output/emina-output.txt

python3 automation-files/count-decision-vars.py

# DONE. Now go check out: output-files/decision-vars-output/decision-vars.csv