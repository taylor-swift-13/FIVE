#!/usr/bin/env python3
from pathlib import Path
import argparse,importlib.util,json
A=Path(__file__).resolve().parent
R=A.parents[6]
s=importlib.util.spec_from_file_location("quat_receipts",R/"paparazzi/report/quat_rotation_paths/evidence_tools.py")
h=importlib.util.module_from_spec(s);s.loader.exec_module(h)
p=argparse.ArgumentParser();p.add_argument("--record-run");a=p.parse_args()
c=json.loads((A/"check-config.json").read_text());c["root"]=str(R)
print(json.dumps(h.check(c,a.record_run),indent=2))
