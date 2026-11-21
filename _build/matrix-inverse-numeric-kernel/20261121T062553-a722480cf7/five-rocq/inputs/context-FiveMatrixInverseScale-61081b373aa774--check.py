from pathlib import Path
import argparse,importlib.util,json,sys
here=Path(__file__).resolve().parent
root=here.parents[4]
spec=importlib.util.spec_from_file_location("matrix_evidence_tools",root/"paparazzi/report/quat_rotation_paths/evidence_tools.py")
h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
p=argparse.ArgumentParser();p.add_argument("--record-run");args=p.parse_args()
config=json.loads((here/"evidence/check-config.json").read_text())
closure=h.dependency_order(root,config["mappings"],config["modules"],config["imports"])
config["gate_inputs"]=list(dict.fromkeys(config["gate_inputs"]+[str(path.relative_to(root))for _,path in closure]+config["extra_inputs"]))
if args.record_run:
 sys.path.insert(0,str(root/"scripts"));from five_telemetry import Run
 run=Run(args.record_run)
 for name,path in closure:h._safe_capture(run,path,"original-module-"+name)
 for path in config["gate_inputs"]:h._safe_capture(run,root/path,"original-context-"+__import__("hashlib").sha256(path.encode()).hexdigest()[:20])
print(json.dumps(h.check(config,args.record_run),indent=2))
