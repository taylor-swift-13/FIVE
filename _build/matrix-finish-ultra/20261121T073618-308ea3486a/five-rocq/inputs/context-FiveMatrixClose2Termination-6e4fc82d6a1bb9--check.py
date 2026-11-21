#!/usr/bin/env python3
"""Rebuild the frozen project closure and certify all exact requested goals."""
from pathlib import Path
import argparse,importlib.util,json
root=Path(__file__).resolve().parents[7]
attempt=Path(__file__).resolve().parent
parser=argparse.ArgumentParser();parser.add_argument('--record-run');args=parser.parse_args()
spec=importlib.util.spec_from_file_location('five_matrix_checker',root/'paparazzi/report/quat_rotation_paths/evidence_tools.py')
checker=importlib.util.module_from_spec(spec);spec.loader.exec_module(checker)
config=json.loads((attempt/'checker-config.json').read_text());config['root']=str(root)
if not args.record_run:config.pop('build',None)
print(json.dumps(checker.check(config,record_run=args.record_run),indent=2))
