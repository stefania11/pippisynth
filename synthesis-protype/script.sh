#! bash

python3 automate-emina.py
python3 automate-ras.py

# echo "EMINA:"
# echo ""
racket output-files/emina-trial.rkt

# echo ""
# echo ""
# echo "RAS:"
# echo ""
# echo ""
racket output-files/ras-trial.rkt
