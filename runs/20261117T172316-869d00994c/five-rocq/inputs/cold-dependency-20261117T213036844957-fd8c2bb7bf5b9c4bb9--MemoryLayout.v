From Stdlib Require Import List ZArith.
From compcert Require Import Errors Maps AST Integers Values Memory Globalenvs Ctypes Csem.
From PidPositionRunPos Require Import Source Execution.
Import ListNotations.
Open Scope Z_scope.
Module Source := PidPositionRunPos.Source.
Module Execution := PidPositionRunPos.Execution.
Definition ce := Source.prog.(prog_comp_env).
Definition composite_member (sid fid:ident) (is_union:bool) : option(type*Z) :=
 match PTree.get sid ce with
 | None=>None
 | Some co=>match field_type fid (co_members co) with
   | Error _=>None
   | OK ty=>if is_union then Some(ty,0) else
     match field_offset ce fid (co_members co) with
     | OK (ofs,_)=>Some(ty,ofs) | Error _=>None end
   end
 end.
Definition one_member (ty:type) (fid:ident) : option(type*Z) :=
 match ty with
 | Tstruct sid _=>composite_member sid fid false
 | Tunion sid _=>composite_member sid fid true
 | _=>None end.
Fixpoint path_info (ty:type) (path:list ident) {struct path} : option(type*Z) :=
 match path with
 | []=>Some(ty,0)
 | f::fs=>match one_member ty f with
   | None=>None | Some(next,ofs)=>match path_info next fs with
     | None=>None | Some(final,tail)=>Some(final,ofs+tail) end end end.
Definition gh_type := Tstruct Source._HorizontalGuidance noattr.
Definition state_type := Tstruct Source._State noattr.
Definition pid_type := Tstruct Source._GuidancePID noattr.
Definition sp_type := Tstruct Source._StabilizationSetpoint noattr.
Definition vec_type := Tstruct Source._Int32Vect2 noattr.
Definition store_path (chunk:memory_chunk) (m:mem) (b:block) (ty:type) (path:list ident) (v:val) : option mem :=
 match path_info ty path with None=>None | Some(_,ofs)=>Mem.store chunk m b ofs v end.
Definition load_path (chunk:memory_chunk) (m:mem) (b:block) (ty:type) (path:list ident) : option val :=
 match path_info ty path with None=>None | Some(_,ofs)=>Mem.load chunk m b ofs end.
Definition store_global (chunk:memory_chunk) (m:mem) (id:ident) (ty:type) (path:list ident) (v:val) : option mem :=
 match Genv.find_symbol Execution.ge id with
 | None=>None | Some b=>store_path chunk m b ty path v end.
Definition load_global (chunk:memory_chunk) (m:mem) (id:ident) (ty:type) (path:list ident) : option val :=
 match Genv.find_symbol Execution.ge id with
 | None=>None | Some b=>load_path chunk m b ty path end.
