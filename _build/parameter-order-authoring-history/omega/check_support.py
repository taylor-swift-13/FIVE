import os,sys,pathlib
os.chdir('/home/yangfp/five');sys.path.insert(0,'scripts')
from five_telemetry import Run
c=pathlib.Path('paparazzi/models/gh_set_omega');r=Run((c/'rocq/session-run.txt').read_text())
flags=['-Q','paparazzi/models/gh_set_zeta/align/model','FiveGhSetZeta','-Q',str(c/'align/model'),'FiveGhSetOmega','-Q',str(c/'rocq/support'),'FiveGhSetOmegaProof','-Q',str(c/'rocq/shared'),'FiveShared','-Q','paparazzi/relations/parameter_order/support','FivePaparazziState']
for name in sys.argv[1:]:
 p=(pathlib.Path('paparazzi/relations/parameter_order/support')/(name[4:]+'.v')) if name.startswith('rel/') else (c/'rocq/shared'/(name[7:]+'.v') if name.startswith('shared/') else c/'rocq/support'/(name+'.v'))
 try:r.command(['/home/yangfp/.opam/five/bin/rocq','compile',*flags,str(p)],'compile-'+name,timeout=180)
 except Exception as ex:
  cmd=r.read('commands.json')[-1];print((r.folder/cmd['stdout']).read_text());print((r.folder/cmd['stderr']).read_text());raise
print('compiled',sys.argv[1:])
