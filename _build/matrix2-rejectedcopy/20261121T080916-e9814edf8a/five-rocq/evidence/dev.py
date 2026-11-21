import pathlib,sys,shlex,shutil
root=pathlib.Path("/home/yangfp/five")
sys.path.insert(0,str(root/"scripts"))
from five_telemetry import Run
r=Run(root/"_build/matrix2-rejectedcopy/20261121T080916-e9814edf8a/five-rocq")
build=root/"_build/matrix-inv2-csem/development/current"
target=build/"FiveInv2Case/RejectedCopyComposition.v"
src=root/"paparazzi/models/float_mat_inv_2d/rocq/support/RejectedCopyComposition.v"
r.command(["cp",str(src),str(target)],"stage-rejected-composition-"+sys.argv[1],30,cwd=root)
flags=[]
for d in sorted(build.iterdir()):
 if d.is_dir():flags.extend(["-Q",str(d),d.name])
c=r.command(["bash","-lc","source scripts/env.sh && rocq compile "+shlex.join(flags+[str(target)])],"compile-rejected-composition-"+sys.argv[1],180,cwd=root)
print((r.folder/c["stdout"]).read_text())
