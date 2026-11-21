from pathlib import Path
from fractions import Fraction as Q
import random,json
r=Path('/home/yangfp/five')
s=(r/'paparazzi/models/guidance_pid_h_run_pos/prepare/source/guidance_pid_h_run_pos.c').read_text()
for line in ['#define INT32_ANGLE_FRAC 12','#define GH_GAIN_SCALE 2','#define INT32_ACCEL_FRAC 10','#define INT32_POS_FRAC 8','#define INT32_SPEED_FRAC 19']:
 assert line in s,line
def clip(x,l):return min(max(x,-l),l)
rng=random.Random(20261119);checked=0
for trial in range(500):
 kp,kd,ki,kv,ka=[rng.randrange(101) for _ in range(5)]
 j=rng.randrange(-100000000,100000001);jr=Q(j)
 d=Q(3*kd,131072);a=2+d
 for n in range(1,21):
  ep=rng.randrange(-4096,4097);ev=rng.randrange(-20000,20001)
  vs=rng.randrange(-10000,10001);ac=rng.randrange(-10000,10001)
  pd=(kp*ep)//64+(kd*(ev//4))//32768
  pdr=Q(kp*ep,64)+Q(kd*ev,131072)
  ff=(kv*vs)//131072+(ka*ac)//256
  ffr=Q(kv*vs,131072)+Q(ka*ac,256)
  j=clip(j+ki*pd,1429*65536)
  jr=clip(jr+ki*pdr,1429*65536)
  u=clip(clip(pd+ff,1429)+j//65536,3216)
  ur=clip(clip(pdr+ffr,1429)+jr/65536,3216)
  assert 0<=jr-j<=n*ki*a
  assert 0<=ur-u<=min(Q(5716),5+d+Q(n*ki,65536)*a)
  checked+=1
print(json.dumps({'role':'finite arithmetic diagnostic only, not Csem proof or replacement execution model',
 'actual_source_scale_check':True,'symbolic_candidate':'0<=u_ref-u_C<=min(5716,5+3kd/131072+n*ki*(2+3kd/131072)/65536)',
 'diagnostic_cases':checked,'random_seed':20261119,'candidate_not_refuted':True,
 'formal_arbitrary_n_original_Csem_proof':'owned by Sol Ultra proof agent; pending'},indent=2))

