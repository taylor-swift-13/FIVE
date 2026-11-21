#!/usr/bin/env python3
from pathlib import Path
import importlib.util
root=next(p for p in Path(__file__).resolve().parents if(p/'scripts/env.sh').is_file())
spec=importlib.util.spec_from_file_location('pprz_replay',root/'paparazzi/relations/trig_plain_compressed_12/evidence/replay.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
module.run('PprzTrigLowTerminationProof.Proof')
