#!/usr/bin/env python3
from pathlib import Path
import runpy
root=next(p for p in Path(__file__).resolve().parents if (p/"scripts/env.sh").is_file())
runpy.run_path(str(root/"paparazzi/relations/trig_plain_compressed_12/evidence/replay.py"))["run"]('PprzTrigPlainCorrespondenceProof.Proof')
