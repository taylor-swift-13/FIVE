from pathlib import Path
import runpy
import sys

if "--cbmc" not in sys.argv:
    sys.argv.append("--cbmc")
runpy.run_path(
    str(Path(__file__).resolve().parents[6] / "relations/pid_position_translation/attempts/002/check.py"),
    run_name="__main__",
)
