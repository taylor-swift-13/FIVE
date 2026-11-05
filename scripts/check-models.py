"""Backward-compatible entry to the canonical example validator and active proof rebuilds."""
from pathlib import Path
import subprocess,sys
root=Path(__file__).resolve().parents[1]
raise SystemExit(subprocess.call([sys.executable,str(root/"scripts/check-example-artifacts.py"),"--compile",*sys.argv[1:]],cwd=root))
