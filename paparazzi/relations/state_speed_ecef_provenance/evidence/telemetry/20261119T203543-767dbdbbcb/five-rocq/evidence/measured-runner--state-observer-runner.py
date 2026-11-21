import sys,json,resource
from pathlib import Path
resource.setrlimit(resource.RLIMIT_AS,(3*1024**3,3*1024**3))
sys.path.insert(0,"scripts")
from five_telemetry import Run
r=Run(Path("/tmp/state-observer-run").read_text())
parent=Path("_build/state-speed-ecef-provenance/getter-ultra-run.txt").read_text().strip()
commands=json.loads((Path(parent)/"run.json").read_text())["commands"]
base=[c["argv"]for c in commands if "SourceComparison" in c["id"]and c["status"]=="passed"][-1][2:-1]
flags=[x for x in base if x!="-time"]+["-Q","paparazzi/models/stateGetSpeedEcef_f/rocq/cbmc_recheck/problem","StateSpeedGetEcefFRecheckProblem","-Q","paparazzi/models/stateGetSpeedEcef_f/rocq/cbmc_recheck/attempts/001","StateSpeedGetEcefFRecheckAttempt001"]
action=sys.argv[1];source=sys.argv[2]
if action=="compile":r.capture(source,"source-before-command-"+str(len(r.read("commands.json"))+1),area="inputs")
rec=r.command(["rocq",action]+flags+[source],"observer-"+action+"-"+Path(source).stem,timeout=100)
print("PASS",rec["id"])
print((r.folder/rec["stdout"]).read_text()[-4500:])
