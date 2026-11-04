From Stdlib Require Import List String ZArith.
From compcert Require Import AST Values Memory Events Globalenvs Determinism Ctypes Csyntax Csem Cexec Smallstep.
From Paparazzi.state_2 Require Import Source.
Import ListNotations.
Definition ge := Csem.globalenv Source.prog.
Definition entry(args:list val)(m:mem):Csem.state :=
  Callstate(Ctypes.Internal Source.f_stateGetPositionNed_i)args Kstop m.
Definition callback := string -> signature -> Senv.t -> world -> list val -> mem ->
  option(world*trace*val*mem).
Definition transitions(cb asm:callback)(w:world)(s:Csem.state):list Cexec.transition :=
  Cexec.do_step ge cb asm w s.
Definition model_step(cb asm:callback)(w:world)(_:unit)(s:Csem.state)(t:trace)(s':Csem.state):Prop :=
  exists rule,In(TR rule t s')(transitions cb asm w s).
Definition normal_return(s:Csem.state):Prop := exists v m,s=Returnstate v Kstop m.
Definition source_error(s:Csem.state):Prop := ~normal_return s /\ nostep Csem.step ge s.
Definition observe_bytes(m:mem)(b:block)(ofs n:Z) := Mem.loadbytes m b ofs n.
(* This adapter is only for call-free, quiet cases with a checked coverage proof.
   None means no implemented callback; it is NOT an automatic C error diagnosis.
   Traceful worlds require a separately checked driver/world evolution. *)
Definition no_external:callback := fun _ _ _ _ _ _ => None.
Definition quiet_world:world := World(fun _ _=>None)(fun _ _ _=>None)(fun _ _ _ _=>None).
Definition closed_transitions := transitions no_external no_external quiet_world.
