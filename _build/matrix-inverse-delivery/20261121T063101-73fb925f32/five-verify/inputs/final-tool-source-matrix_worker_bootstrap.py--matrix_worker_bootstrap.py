import sys,json
from pathlib import Path
sys.path.insert(0,'/home/yangfp/five/scripts')
from five_telemetry import Run
root=Path('/home/yangfp/five'); session='/mnt/c/Users/50635/.codex/sessions/2026/11/21/rollout-2026-11-21T13-28-05-01a1fc93-76e8-7851-bb45-94b22e20ae52.jsonl'
run=Run.start(root/'_build/matrix-inverse-prepare','five-prepare',[],{'entries':['float_mat_inv_2d','float_mat_inv_3d'],'requested_model':'gpt-6.1-sol','requested_reasoning_effort':'ultra','shared_scope':'both inverse cases'},usage_session=session,invocation_kind='skill-session')
(root/'_build/matrix_inverse_prepare_run.txt').write_text(str(run.folder))
print(run.folder)
