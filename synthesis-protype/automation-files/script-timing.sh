#! bash
set -v

python3 automation-files/automate-emina-timing.py
python3 automation-files/automate-ras-timing.py
python3 automation-files/automate-choose-star.py

racket output-files/generated-racket-files/ras-trial-timing.rkt
racket output-files/generated-racket-files/emina-trial-timing.rkt
racket output-files/generated-racket-files/choose-star-trial-timing.rkt


# Done. Now go check out:
#     output-files/timing-output/ras-timing.csv
#     output-files/timing-output/emina-timing.csv
#     output-files/timing-output/choose-star-timing.csv